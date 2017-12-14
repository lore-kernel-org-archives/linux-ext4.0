From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: FS: EXT4: should we sync error info in __ext4_grp_locked_error?
Date: Thu, 14 Dec 2017 11:48:05 -0500
Message-ID: <20171214164805.lbbsr7nyakhvujes@thunk.org>
References: <CAABZP2w39PEBue-L1kGk-jh_WQohTtaVJHy-wS_E7QC28FKJSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        inux-fsdevel@vger.kernel.org
To: Zhouyi Zhou <zhouzhouyi@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAABZP2w39PEBue-L1kGk-jh_WQohTtaVJHy-wS_E7QC28FKJSA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Dec 14, 2017 at 03:13:15PM +0800, Zhouyi Zhou wrote:
> Hi,
>     In function __ext4_grp_locked_error,   __save_error_info(sb, function, line)
> is called to save error info in super block block, but does not sync
> that information
> to disk to info the subsequence fsck after reboot. The reason, I guess
> maybe it is
> in locked state.
>     My question is why not make a call ext4_commit_super(sb, 1) after
> ext4_unlock_group(sb, grp) and  ext4_handle_error(sb), so that subsequence fsck
> after reboot is sure to be well informed.

Adding ext4_commit_super(sb, 1) between the calls to
ext4_unlock_group() and ext4_handle_error() is a good idea; it's not a
naive suggestion at all.

Cheers,

					- Ted
