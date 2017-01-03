From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] ext4: Find desired extent in
 ext4_ext_shift_extents() using binsearch
Date: Tue, 3 Jan 2017 09:40:41 -0500
Message-ID: <20170103144041.t5lmorkdqqljnwvl@thunk.org>
References: <20170102125450.22807-1-roman.penyaev@profitbricks.com>
 <20170102125450.22807-4-roman.penyaev@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Namjae Jeon <namjae.jeon@samsung.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Roman Pen <roman.penyaev@profitbricks.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170102125450.22807-4-roman.penyaev@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jan 02, 2017 at 01:54:50PM +0100, Roman Pen wrote:
> The aim of this patch is to optimize a search of an extent while
> doing right shift using binsearch.
> 
> Cc: Namjae Jeon <namjae.jeon@samsung.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: linux-ext4@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org

I would really appreciate it if patches that touch sensitive code (and
the extents manipulation code is an example of code which is fairly
subtle and fragile) are tested using xfstests first before you submit
them for review.  I've done a lot of work to make using xfstests
simple and easy for ext4 developers.  See:

	http://thunk.org/gce-xfstests

(especially the last slide :-).

BEGIN TEST 4k: Ext4 4k block Mon Jan  2 23:06:02 EST 2017
Failures: generic/061 generic/063 generic/075 generic/091 generic/112 generic/127 generic/231 generic/263 generic/389
BEGIN TEST 1k: Ext4 1k block Mon Jan  2 23:56:29 EST 2017
Failures: ext4/307 generic/013 generic/014 generic/016 generic/018 generic/020 generic/021 generic/022 generic/023
generic/024 generic/025 generic/028 generic/035 generic/036 generic/058 generic/060 generic/061 generic/063 generic/067
generic/070 generic/072 generic/074 generic/075 generic/077 generic/078 generic/080 generic/081 generic/082 generic/086
generic/087 generic/088 generic/089 generic/091 generic/092 generic/100 generic/112 generic/113 generic/114 generic/117
generic/123 generic/124 generic/126 generic/127 generic/131 generic/133 generic/184 generic/192 generic/193 generic/198
generic/207 generic/208 generic/209 generic/210 generic/211 generic/212 generic/213 generic/214 generic/215 generic/221
generic/228 generic/231 generic/233 generic/236 generic/237 generic/239 generic/240 generic/241 generic/245 generic/246
generic/247 generic/248 generic/249 generic/255 generic/256 generic/257 generic/258 generic/263 generic/269 generic/270
generic/273 generic/285 generic/286 generic/299 generic/300 generic/306 generic/308 generic/309 generic/310 generic/313
generic/314 generic/315 generic/316 generic/323 generic/355 generic/360 generic/361 generic/375 generic/378 generic/389
generic/391 shared/298

The 1k test failures look extremely scary, but that's because
generic/013 corrupted the file system, and caused all of the
subsequent tests using the test device to fail.  Of course, patches
_shouldn't_ be corrupting file systems.  That's a regression which
makes everyone said.  :-)

						- Ted
