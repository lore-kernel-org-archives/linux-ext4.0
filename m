From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fix: print ext4 mountopt data_err=abort correctly
Date: Sat, 12 Mar 2016 21:57:05 -0500
Message-ID: <20160313025705.GB29218@thunk.org>
References: <1457528979-25737-1-git-send-email-alnovak@suse.cz>
 <1457548240-30948-1-git-send-email-alnovak@suse.cz>
 <1457548240-30948-2-git-send-email-alnovak@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Ales Novak <alnovak@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1457548240-30948-2-git-send-email-alnovak@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Mar 09, 2016 at 07:30:40PM +0100, Ales Novak wrote:
> If data_err=abort option is specified for an ext3/ext4 mount,
> /proc/mounts does show it as "(null)". This is caused by token2str()
> returning NULL for Opt_data_err_abort (due to its pattern containing
> '=').
> 
> This is perhaps more logical solution than the previously submitted,
> handling these 'data_err=' options in other way than MOPT_SET.
> 
> Signed-off-by: Ales Novak <alnovak@suse.cz>

Thanks, applied.

						- Ted
