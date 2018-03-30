From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] ext4: protect i_disksize update by i_data_sem in direct
 write path
Date: Fri, 30 Mar 2018 14:14:02 -0400
Message-ID: <20180330181402.GC9300@thunk.org>
References: <20180312152156.14034-2-guaneryu@gmail.com>
 <DM5PR2101MB103262C4DC678FEC128E851BFBA10@DM5PR2101MB1032.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
To: Sasha Levin <Alexander.Levin@microsoft.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <DM5PR2101MB103262C4DC678FEC128E851BFBA10@DM5PR2101MB1032.namprd21.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Mar 30, 2018 at 04:16:10PM +0000, Sasha Levin wrote:
> 
> Here's a mail that would be sent as a result of an autoselection. It
> will note the "score" of the patch, and will run the same tests we
> do for patches tagged for stable.
> 
> As before, please let me know your thoughts on this. Thanks!
> ...
> 
> Please let us know if you'd like to have this patch included in a stable tree.

This patch is in the ext4 tree but has not been integrated into the
mainline kernel.  It will be shortly, once the merge window opens.

How are patches selected for potential autoselection?  If they are in
linux-ext but not yet in mainline, I would assume this would be a
reason not to select it, no?

Regards,

					- Ted
