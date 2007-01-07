From: Rene Herman <rene.herman@gmail.com>
Subject: Re: How git affects kernel.org performance
Date: Sun, 07 Jan 2007 10:38:20 +0100
Message-ID: <45A0BF8C.4040508@gmail.com>
References: <20061216094421.416a271e.randy.dunlap@oracle.com>	<20061216095702.3e6f1d1f.akpm@osdl.org>	<458434B0.4090506@oracle.com>	<1166297434.26330.34.camel@localhost.localdomain>	<1166304080.13548.8.camel@nigel.suspend2.net>	<459152B1.9040106@zytor.com>	<1168140954.2153.1.camel@nigel.suspend2.net>	<45A08269.4050504@zytor.com>	<45A083F2.5000000@zytor.com>	<Pine.LNX.4.64.0701062130260.3661@woody.osdl.org>	<20070107085526.GR24090@1wt.eu> <20070107011542.3496bc76.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Willy Tarreau <w@1wt.eu>, Linus Torvalds <torvalds@osdl.org>,
	"H. Peter Anvin" <hpa@zytor.com>, git@vger.kernel.org,
	nigel@nigel.suspend2.net, "J.H." <warthog9@kernel.org>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Pavel Machek <pavel@ucw.cz>,
	kernel list <linux-kernel@vger.kernel.org>,
	webmaster@kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932460AbXAGJkA@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
In-Reply-To: <20070107011542.3496bc76.akpm@osdl.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 01/07/2007 10:15 AM, Andrew Morton wrote:

> Yeah, slowly-growing directories will get splattered all over the
> disk.
> 
> Possible short-term fixes would be to just allocate up to (say) eight
>  blocks when we grow a directory by one block.  Or teach the 
> directory-growth code to use ext3 reservations.
> 
> Longer-term people are talking about things like on-disk
> rerservations. But I expect directories are being forgotten about in
> all of that.

I wish people would just talk about de2fsrag... ;-\

Rene
