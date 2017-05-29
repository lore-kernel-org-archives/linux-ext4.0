From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix fdatasync(2) after extent manipulation
 operations
Date: Mon, 29 May 2017 14:30:27 -0400
Message-ID: <20170529183027.ddn7o4jeck7urro7@thunk.org>
References: <20170525142524.18254-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, stable@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170525142524.18254-1-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, May 25, 2017 at 04:25:24PM +0200, Jan Kara wrote:
> Currently, extent manipulation operations such as hole punch, range
> zeroing, or extent shifting do not record the fact that file data has
> changed and thus fdatasync(2) has a work to do. As a result if we crash
> e.g. after a punch hole and fdatasync, user can still possibly see the
> punched out data after journal replay. Test generic/392 fails due to
> these problems.
> 
> Fix the problem by properly marking that file data has changed in these
> operations.
> 
> CC: stable@vger.kernel.org
> Fixes: a4bb6b64e39abc0e41ca077725f2a72c868e7622
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
