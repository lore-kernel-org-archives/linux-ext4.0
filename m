From: David Sterba <dave@jikos.cz>
Subject: Re: [RFC v3 01/13] btrfs: add one new mount option '-o hot_track'
Date: Thu, 11 Oct 2012 16:41:41 +0200
Message-ID: <20121011144141.GD4405@twin.jikos.cz>
References: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
 <1349863655-29320-2-git-send-email-zwu.kernel@gmail.com>
 <20121010162842.GZ4405@twin.jikos.cz>
 <CAEH94LgJDhB+-mjhBScQnQybqYWE1rJ6ViuqeWNisLjC=8yMkA@mail.gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dave@jikos.cz, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	viro@zeniv.linux.org.uk, david@fromorbit.com, tytso@mit.edu,
	cmm@us.ibm.com, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAEH94LgJDhB+-mjhBScQnQybqYWE1rJ6ViuqeWNisLjC=8yMkA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Oct 11, 2012 at 10:35:28PM +0800, Zhi Yong Wu wrote:
> >> --- a/fs/btrfs/super.c
> >> +++ b/fs/btrfs/super.c
> >> @@ -303,7 +304,7 @@ enum {
> >>       Opt_notreelog, Opt_ratio, Opt_flushoncommit, Opt_discard,
> >>       Opt_space_cache, Opt_clear_cache, Opt_user_subvol_rm_allowed,
> >>       Opt_enospc_debug, Opt_subvolrootid, Opt_defrag, Opt_inode_cache,
> >> -     Opt_no_space_cache, Opt_recovery, Opt_skip_balance,
> >> +     Opt_no_space_cache, Opt_recovery, Opt_skip_balance, Opt_hot_track,
> >
> > Please add the new option to the end.
> To be honest, it can't be added to the end, if you check Opt_err's
> pattern value, you will find it is NULL, it will cause match_one()
> return 1. So if we add Opt_hot_track to the end of this array, it will
> be covered by match_token(), so i prefer to add it to
> Opt_fatal_errors. Do you think of it?

Ah, sorry, I was not clear what the 'end' means here. The Opt_err is a
end-of-the-list token, so yes please add hot_track between
Opt_fatal_errors and Opt_err.

david
