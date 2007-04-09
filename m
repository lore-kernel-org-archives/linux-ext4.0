From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: Add a norecovery option to ext3/4?
Date: Mon, 9 Apr 2007 18:37:58 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0704091835520.21426@yvahk01.tjqt.qr>
References: <20070409000556.GA13980@implementation> <4619B202.3050601@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753586AbXDIQjk@vger.kernel.org>
In-Reply-To: <4619B202.3050601@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


On Apr 8 2007 22:24, Eric Sandeen wrote:
> Samuel Thibault wrote:
>
> Can you elaborate?  Under what circumstances is log replay going to harm data?
> Do you mean that the installer mounts partitions, looking for what OS is
> installed?  How is that harmful?
>
> Hm, so the root cause there seems that the installer found 2 legs of a mirror
> and mounted them independently, recovering them independently... But why did
> that cause problems?

Because, for whatever unlikely reason there could possibly be, it may
have been repaired differently [depending on sunshine, daytime, rand(), 
or so]?


Jan
-- 
