From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix bh leak on error paths in ext4_rename() and
 ext4_cross_rename()
Date: Thu, 2 Apr 2015 16:36:28 -0400
Message-ID: <20150402203628.GB450@thunk.org>
References: <20150303111719.26916.92177.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150303111719.26916.92177.stgit@buzz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Mar 03, 2015 at 02:17:19PM +0300, Konstantin Khlebnikov wrote:
> Release references to buffer-heads if ext4_journal_start() fails.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> Fixes: 5b61de757535 ("ext4: start handle at least possible moment when renaming files")

Thanks, applied.

						- Ted
