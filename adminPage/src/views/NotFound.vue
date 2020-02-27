<template>
    <div class="404">
        <div class="section">
            <h1 class="title">404 Not Found</h1>
            <h3 class="subtitle">Where are you going?</h3>
            <p>This page doesn't exist.</p>
            <b-button tag="router-link" :to="{name: 'home'}">
                Back to Home
            </b-button>
        </div>
    </div>
</template>