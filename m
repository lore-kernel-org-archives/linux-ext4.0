From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: dump/restore not supported for ext4
Date: Fri, 05 Mar 2010 07:23:34 +0100
Message-ID: <4B90A366.9080201@gmail.com>
References: <alpine.DEB.2.00.1003041704230.17723@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1003041704230.17723@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 03/04/10 23:05, Justin Piszcz wrote:
> Hi,
> 
> I should have researched it more:
> 
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=511651
> https://lists.ubuntu.com/archives/universe-bugs/2009-June/098729.html
> 
> Looks like it's broken, I agree with the reporters, dump should abort if
> it is dealing with an ext4 filesystem, since you cannot restore data
> from an ext4 dump.
> 
> Justin.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Hi Justin,

It seems you are using an outdated version of dump.
The latest version of dump, 0.4b42 does contain support for ext4.
I've been using it for the last 8 months for my backups of ext4 without
any problems and restoring is not issue at all with this version.

---
Gertjan.
