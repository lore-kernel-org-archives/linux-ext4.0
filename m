From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH] ext2: fix missing mutex_unlock in error path
Date: Tue, 14 Apr 2009 18:35:45 +0900
Message-ID: <20090414093545.GA10092@localhost.localdomain>
References: <20090414073631.GA4145@localhost.localdomain> <20090414074356.GC398@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754841AbZDNJgG@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090414074356.GC398@duck.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Apr 14, 2009 at 09:43:57AM +0200, Jan Kara wrote:
>   Thanks for the patch but I already have this patch in my quota tree from
> Dan Carpenter...

Oh, I should have checked your tree.
BTW, JFS still have same problem in jfs_quota_write() 
