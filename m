From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: complain about descriptor block checksum errors
Date: Mon, 19 Jan 2015 16:11:22 -0500
Message-ID: <20150119211122.GH11708@thunk.org>
References: <20150108200334.GB9976@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150108200334.GB9976@birch.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jan 08, 2015 at 12:03:34PM -0800, Darrick J. Wong wrote:
> We should complain in dmesg when journal recovery fails on account of
> the descriptor block being corrupt, so that the diagnostic data can
> be recovered.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
