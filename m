From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: Can one file system be R/W mounted multiple times in Linux?
Date: Fri, 9 Jan 2015 20:37:11 +0000
Message-ID: <20150109203711.GJ22149@ZenIV.linux.org.uk>
References: <F792CF86EFE20D4AB8064279AFBA51C61EA72765@SIXPRD3002MB028.064d.mgd.msft.net>
 <20150109035123.GG22149@ZenIV.linux.org.uk>
 <20150109120159.GA20300@stefanha-thinkpad.redhat.com>
 <alpine.LFD.2.00.1501091646400.24821@localhost.localdomain>
 <CA+aCy1Esm-2NGvJFG4_22rNaXiOqx1f2beCPpSCcovrXFf07+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>, kzak@redhat.com,
	Dexuan Cui <decui@microsoft.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Pranay Srivastava <pranjas@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+aCy1Esm-2NGvJFG4_22rNaXiOqx1f2beCPpSCcovrXFf07+A@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Jan 10, 2015 at 01:01:19AM +0530, Pranay Srivastava wrote:

> It's not the mount. If you see mount_bdev it checks for this and uses
> the existing super block from the first mount
> for all subsequent mounts of that block device.
> 
> When block devices differ, as in with 2 loop devices they have
> different bdev and that's why it doesn't work with 2
> loop devices.

What Lukas is suggesting is for mount(8) to spot an existing loop device with
the desired backing store and reuse it, rather than try and set the new one
up.  That's where -o loop is handled - it's gone before mount(2) might see
it.  The problem is in races...
