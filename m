From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/6] ext[24]: MBCache rewrite
Date: Wed,  9 Dec 2015 18:57:32 +0100
Message-ID: <1449683858-28936-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Laurent GUERBY <laurent@guerby.net>,
	Andreas Dilger <adilger@dilger.ca>, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33121 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100AbbLIR5q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Dec 2015 12:57:46 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

inspired by recent reports [1] of problems with mbcache I had a look into what
we could to improve it. I found the current code rather overengineered
(counting with single entry being in several indices, having homegrown
implementation of rw semaphore, ...).

After some thinking I've decided to just reimplement mbcache instead of
improving the original code in small steps since the fundamental changes in
locking and layout would be actually harder to review in small steps than in
one big chunk and overall the new mbcache is actually pretty simple piece of
code (~450 lines).

The result of rewrite is smaller code (almost half the original size), smaller
cache entries (7 longs instead of 13), and better performance (see below
for details).

For measuring performance of mbcache I have written a stress test (I called it
xattr-bench). The test spawns P processes, each process sets xattr for F
different files, and the value of xattr is randomly chosen from a pool of V
values. Each process runs until it sets extended attribute 50000 times (this is
arbitrarily chosen number so that run times for the particular test machine are
reasonable). The test machine has 24 CPUs and 64 GB of RAM, the test filesystem
was created on ramdisk. Each test has been run 5 times.

I have measured performance for original mbache, new mbcache2 code where LRU
is implemented as a simple list, mbcache2 where LRU is implemented using
list_lru, and mbcache2 where we keep LRU lazily and just use referenced bit.
I have also measured performance when mbcache was completely disabled (to
be able to quantify how much gain can some loads get from disabling mbcache).
The graphs for different combinations of parameters (I have measured
P=1,2,4,8,16,32,64; F=10,100,1000; V=10,100,1000,10000,100000) can be found
at [2].

Based on the numbers I have chosen the implementation using LRU with referenced
bit for submission. Implementation using list_lru is faster in some heavily
contended cases but slower in most of the cases so I figured it is not worth
it. My measurements show that completely disabling mbcache can still result
in upto ~2x faster execution of the benchmark so even after improvements
there is some gain users like Lustre or Ceph could have from completely
disabling mbcache.

Here is a comparison table with averages of 5 runs. Measured numbers are in
order "old mbcache", "mbcache2 with normal LRU", "mbcache2 with list_lru LRU",
"mbcache2 with referenced bit", "disabled mbcache". Note that some numbers for
"old mbcache" are not available since the machine just dies due to softlockups
under the pressure.

V=10
F\P	1				2				4				8				16				32				64
10	0.158,0.157,0.209,0.155,0.135	0.208,0.196,0.263,0.229,0.154	0.500,0.277,0.364,0.305,0.176	0.798,0.400,0.380,0.384,0.237	3.258,0.584,0.593,0.664,0.500	13.807,1.047,1.029,1.100,0.986	61.339,2.803,3.615,2.994,1.799
100	0.172,0.167,0.161,0.185,0.126	0.279,0.222,0.244,0.222,0.156	0.520,0.275,0.275,0.273,0.199	0.825,0.341,0.408,0.333,0.217	2.981,0.505,0.523,0.523,0.315	12.022,1.202,1.210,1.125,1.293	44.641,2.943,2.869,3.337,13.056
1000	0.185,0.174,0.187,0.153,0.160	0.297,0.239,0.247,0.227,0.176	0.445,0.283,0.276,0.272,0.957	0.767,0.340,0.357,0.324,1.975	2.329,0.480,0.498,0.476,5.391	6.342,1.198,1.235,1.204,8.283	16.440,3.888,3.817,3.896,17.878

V=100
F\P	1				2				4				8				16				32				64
10	0.162,0.153,0.180,0.126,0.126	0.200,0.186,0.241,0.165,0.154	0.362,0.257,0.313,0.208,0.181	0.671,0.496,0.422,0.379,0.194	1.433,0.943,0.773,0.676,0.570	3.801,1.345,1.353,1.221,1.021	7.938,2.501,2.700,2.484,1.790
100	0.153,0.160,0.164,0.130,0.144	0.221,0.199,0.232,0.217,0.166	0.404,0.264,0.300,0.270,0.180	0.945,0.379,0.400,0.322,0.240	1.556,0.485,0.512,0.496,0.339	3.761,1.156,1.214,1.197,1.301	7.901,2.484,2.508,2.526,13.039
1000	0.215,0.191,0.205,0.212,0.156	0.303,0.246,0.246,0.247,0.182	0.471,0.288,0.305,0.300,0.896	0.960,0.347,0.375,0.347,1.892	1.647,0.479,0.530,0.509,4.744	3.916,1.176,1.288,1.205,8.300	8.058,3.160,3.232,3.200,17.616

V=1000
F\P	1				2				4				8				16				32				64
10	0.151,0.129,0.179,0.160,0.130	0.210,0.163,0.248,0.193,0.155	0.326,0.245,0.313,0.204,0.191	0.685,0.521,0.493,0.365,0.210	1.284,0.859,0.772,0.613,0.389	3.087,2.251,1.307,1.745,0.896	6.451,4.801,2.693,3.736,1.806
100	0.154,0.153,0.156,0.159,0.120	0.211,0.191,0.232,0.194,0.158	0.276,0.282,0.286,0.228,0.170	0.687,0.506,0.496,0.400,0.259	1.202,0.877,0.712,0.632,0.326	3.259,1.954,1.564,1.336,1.255	8.738,2.887,14.421,3.111,13.175
1000	0.145,0.179,0.184,0.175,0.156	0.202,0.222,0.218,0.220,0.174	0.449,0.319,0.836,0.276,0.965	0.899,0.333,0.793,0.353,2.002	1.577,0.524,0.529,0.523,4.676	4.221,1.240,1.280,1.281,8.371	9.782,3.579,3.605,3.585,17.425

V=10000
F\P	1				2				4				8				16				32				64
10	0.161,0.154,0.204,0.158,0.137	0.198,0.190,0.271,0.190,0.153	0.296,0.256,0.340,0.229,0.164	0.662,0.480,0.475,0.368,0.239	1.192,0.818,0.785,0.646,0.349	2.989,2.200,1.237,1.725,0.961	6.362,4.746,2.666,3.718,1.793
100	0.176,0.174,0.136,0.155,0.123	0.236,0.203,0.202,0.188,0.165	0.326,0.255,0.267,0.241,0.182	0.696,0.511,0.415,0.387,0.213	1.183,0.855,0.679,0.689,0.330	4.205,3.444,1.444,2.760,1.249	19.510,17.760,15.203,17.387,12.828
1000	0.199,0.183,0.183,0.183,0.164	0.240,0.227,0.225,0.226,0.179	1.159,1.014,1.014,1.036,0.985	2.286,2.154,1.987,2.019,1.997	6.023,6.039,6.594,5.657,5.069	N/A,10.933,9.272,10.382,8.305	N/A,36.620,27.886,36.165,17.683

V=100000
F\P	1				2				4				8				16				32				64
10	0.171,0.162,0.220,0.163,0.143	0.204,0.198,0.272,0.192,0.154	0.285,0.230,0.318,0.218,0.172	0.692,0.500,0.505,0.367,0.210	1.225,0.881,0.827,0.687,0.338	2.990,2.243,1.266,1.696,0.942	6.379,4.771,2.609,3.722,1.778
100	0.151,0.171,0.176,0.171,0.153	0.220,0.210,0.226,0.201,0.167	0.295,0.255,0.265,0.242,0.175	0.720,0.518,0.417,0.387,0.221	1.226,0.844,0.689,0.672,0.343	3.423,2.831,1.392,2.370,1.354	19.234,17.544,15.419,16.700,13.172
1000	0.192,0.189,0.188,0.184,0.164	0.249,0.225,0.223,0.218,0.178	1.162,1.043,1.031,1.024,1.003	2.257,2.093,2.180,2.004,1.960	5.853,4.997,6.143,5.315,5.350	N/A,10.399,8.578,9.190,8.309	N/A,32.198,19.465,19.194,17.210

Thoughs, opinions, comments welcome.

								Honza

[1] https://bugzilla.kernel.org/show_bug.cgi?id=107301
[2] http://beta.suse.com/private/jack/mbcache2/
