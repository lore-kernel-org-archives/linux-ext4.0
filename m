From: Carlos Maiolino <cmaiolino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Update ext3/4 mount options
Date: Fri, 10 Jan 2014 10:57:07 -0200
Message-ID: <20140110125706.GA14692@orion.maiolino.org>
References: <1389288890-17282-1-git-send-email-cmaiolino@redhat.com>
 <1389299455.29292.68757293.7B539718@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: util-linux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1389299455.29292.68757293.7B539718-2RFepEojUI2N1INw9kWLP6GC3tUn3ZHUQQ4Iyu8u01E@public.gmane.org>
Sender: util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Hi Benno,

thanks for the fixes, despite the journal line, where 'abort the journal' is the
correct meaning, I'm going to apply the other fixes.

On Thu, Jan 09, 2014 at 09:30:55PM +0100, Benno Schulenberg wrote:
> 
> On Thu, Jan 9, 2014, at 18:34, Carlos Maiolino wrote:
> > -have changed, this option allows the user to specify
> > +have changed, these options allows the user to specify
> 
> s/allows/allow/
> 
> > +identified through euther its new major/minor numbers encoded
> > +in devnum, or via a path to the device.
> 
> s/through euther/either through/
> (swapped, otherwise the "via" needs to be dropped)
> 
> > +Abort the journal if an error occurs in a file data buffer in ordered mode.
> 
> "Abort loading the journal..." maybe?
> 
> > +The lazy itable init code will wait n times the number of milliseconds it took
> > +to zero out the previous block group's inode table. This minimizes the impact on
> > +the system performance while filesystem's inode table is being initialized.
> 
> s/the system/system/
> s/while/while the/
> 
> > +useful in memory constrained environments, where a very large directory can
> 
> better: memory-constrained
> 
> > +cause severe performance problems or even provoke the Out Of Memory killer. (For
> > +example, if there is only 512mb memory available, a 176mb directory may
> > +seriously cramp the system's style).
> 
> s/)./.)/
> 
> Benno
> 
> -- 
> http://www.fastmail.fm - Choose from over 50 domains or use your own
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
--
To unsubscribe from this list: send the line "unsubscribe util-linux" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
