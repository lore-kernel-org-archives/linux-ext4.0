From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH RFC 02/30] ext4: snapshot debugging support
Date: Tue, 7 Jun 2011 12:49:00 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1106071244540.4754@dhcp-27-109.brq.redhat.com>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net> <1304959308-11122-3-git-send-email-amir73il@users.sourceforge.net> <alpine.LFD.2.00.1106061659400.3934@dhcp-27-109.brq.redhat.com>
 <BANLkTi=UJQAgPHT4w-jLYHLcbg531T=sRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-694876015-1307443743=:4754"
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: "Amir G." <amir73il@users.sourceforge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906Ab1FGKtM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Jun 2011 06:49:12 -0400
In-Reply-To: <BANLkTi=UJQAgPHT4w-jLYHLcbg531T=sRw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-694876015-1307443743=:4754
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Tue, 7 Jun 2011, Amir G. wrote:

> >
> >> +#define snapshot_test_delay_progress(i, from, to, max)                       \
> >> +     do {                                                            \
> >> +             if (snapshot_enable_test[i] &&                          \
> >> +                             (max) > snapshot_enable_test[i] &&      \
> >> +                             (from) <= (to) && (to) <= (max)) {      \
> >> +                     unsigned long blocks_per_ms =                   \
> >> +                             do_div((max), snapshot_enable_test[i]); \
> >> +                     unsigned long x = do_div((from), blocks_per_ms);\
> >> +                     unsigned long y = do_div((to), blocks_per_ms);  \
> >> +                     if (y > x)                                      \
> >> +                             msleep_interruptible(y - x);            \
> >> +             }                                                       \
> >> +     } while (0)
> >> +
> >> +#define snapshot_debug_l(n, l, f, a...)                                      \
> >> +     do {                                                            \
> >> +             if ((n) <= snapshot_enable_debug &&                     \
> >> +                 (l) <= SNAPSHOT_INDENT_MAX) {                       \
> >> +                     printk(KERN_DEBUG "snapshot: %s" f,             \
> >> +                            snapshot_indent - (l),                   \
> >> +                                ## a);                               \
> >> +             }                                                       \
> >> +     } while (0)
> >
> > This can be done by tracepoints maybe ?
> 
> can you add a generic string arg to a tracepoint?

Yes, you can print whatever you want with  tracepoint printk. See
include/trace/events/ext4.h, Documentation/trace/tracepoints.txt and
Documentation/trace/tracepoints-analysis.txt

Thanks!
-Lukas
--8323328-694876015-1307443743=:4754--
