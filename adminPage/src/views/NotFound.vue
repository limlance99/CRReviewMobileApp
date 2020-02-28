<!--
Authors: JV Afable, JP Chanchico, Lance Lim

This is a course requirement for CS 192 Software Engineering II
under the supervision of Asst. Prof. Ma. Rowena C. Solamo of
the Department of Computer Science, College of Engineering,
University of the Philippines, Diliman for the AY 2019-2020.

Code History:
	Feb 27, 2020: Lance Lim - Initialized file.
-->

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