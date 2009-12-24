From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: benchmark results
Date: Thu, 24 Dec 2009 12:01:37 -0800 (PST)
Message-ID: <alpine.DEB.2.01.0912241157130.3483@bogon.housecafe.de>
References: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de> <b245135e0912240459j3ca92827sc69bb4665f60d8c3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: reiserfs-devel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Teran McKinney <sega01@gmail.com>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <b245135e0912240459j3ca92827sc69bb4665f60d8c3@mail.gmail.com>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

[cut a few Cc's]

On Thu, 24 Dec 2009 at 12:59, Teran McKinney wrote:
> Which I/O scheduler are you using? Pretty sure that ReiserFS is a
> little less deadlocky with CFQ or another over deadline, but that
> deadline usually gives the best results for me (especially for JFS).

Yes, I'm using the deadline scheduler - it was my understanding that it's 
usually best when I/O throughput is an issue. If reiserfs is "less 
deadlocky" with other schedulers, maybe it should depend on 
!IOSCHED_DEADLINE then or something :)

Christian.
-- 
BOFH excuse #19:

floating point processor overflow
