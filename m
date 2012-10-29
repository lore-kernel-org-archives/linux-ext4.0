From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [RFC v4+ hot_track 13/19] debugfs: introduce one function
Date: Mon, 29 Oct 2012 15:54:21 -0700
Message-ID: <20121029225421.GA21772@kroah.com>
References: <1351485061-12297-1-git-send-email-zwu.kernel@gmail.com>
 <1351485061-12297-14-git-send-email-zwu.kernel@gmail.com>
 <20121029181135.GB3605@kroah.com>
 <CAEH94Li_XUxUUJDskO28OSvZPmZB3u_SpLFcVtD-04PivQSS8w@mail.gmail.com>
 <20121029223404.GA20486@kroah.com>
 <CAEH94Lj2baN-EzjTvxURc5ECyfjh9Z+w6NZbNUok3osOLF55ag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	david@fromorbit.com, tytso@mit.edu, cmm@us.ibm.com,
	wuzhy@linux.vnet.ibm.com, wenqing.lz@taobao.com
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAEH94Lj2baN-EzjTvxURc5ECyfjh9Z+w6NZbNUok3osOLF55ag@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Oct 30, 2012 at 06:45:19AM +0800, Zhi Yong Wu wrote:
> On Tue, Oct 30, 2012 at 6:34 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Tue, Oct 30, 2012 at 06:25:50AM +0800, Zhi Yong Wu wrote:
> >> On Tue, Oct 30, 2012 at 2:11 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >> > On Mon, Oct 29, 2012 at 12:30:55PM +0800, zwu.kernel@gmail.com wrote:
> >> >> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> >> >>
> >> >>   The debugfs function is used to get expected dentry.
> >> >
> >> > Huh?  Why do you need this?  Why haven't you added documentation for the
> >> It is used to determine if one sysfs directory has been created. OK, i
> >> will add some doc, thanks for your suggestion.
> >
> > You didn't answer the "why" part here.  How come you think you need
> ah, Let me say its scenario at first. If we do two mount ops as below:
> 1.) mount -o loop,hot_track image1 /data1
> 2.) mount -o loop,hot_track image2 /data2
> 
> The mount -o hot_track operation will automatically create one sysfs
> directory /sys/kernel/debug/hot_track. To prevent this dir being
> created again when 2.) is done, we need to know if it has existed at
> first. In my patch, i at first get its dentry by this new function,
> then determine if its d_inode field is NULL, if no, it means that this
> sysfs dir has existed.
> This is the reason that i want to add one new function.

Why not do like the rest of the kernel does and just have a:
	static dentry *hot_track_root;
and use that as your root debugfs directory dentry:

	if (!hot_track_root) {
		/* Create root directory */
		hot_track_root = debugfs_create(...);
	}

No need to look anything up :)

thanks,

greg k-h
