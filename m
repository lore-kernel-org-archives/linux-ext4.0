From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: add hot tracking support
Date: Mon, 29 Oct 2012 10:32:44 +0800
Message-ID: <20121029023244.GA5319@gmail.com>
References: <1351177747-19389-1-git-send-email-zwu.kernel@gmail.com>
 <1351416170-3735-1-git-send-email-wenqing.lz@taobao.com>
 <CAEH94Li_7Ujk5+ddv12vwi=iWiFRr_mjautHkahjPnbWH6gQVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	cmm@us.ibm.com, wuzhy@linux.vnet.ibm.com,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAEH94Li_7Ujk5+ddv12vwi=iWiFRr_mjautHkahjPnbWH6gQVQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Oct 28, 2012 at 09:45:49PM +0800, Zhi Yong Wu wrote:
[snip]
> On Sun, Oct 28, 2012 at 5:22 PM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> > @@ -864,6 +865,8 @@ static void ext4_put_super(struct super_block *sb)
> >         ext4_ext_release(sb);
> >         ext4_xattr_put_super(sb);
> >
> > +       if (sbi->s_hottrack_enable)
> > +               hot_track_exit(sb);
> >         if (!(sb->s_flags & MS_RDONLY)) {
> >                 EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
> >                 es->s_state = cpu_to_le16(sbi->s_mount_state);
> HI, Zheng,
> 
> Do you not need to free stuff related to hot tracking when umount?

I call hot_track_exit() in put_super callback function.  I have no idea
that there still has some other functions that need to be called.  Am I
missing something?

Regards,
Zheng
