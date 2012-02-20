From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: E2fsprogs 1.42.1 release
Date: Mon, 20 Feb 2012 13:01:52 -0600
Message-ID: <4F4298A0.1000900@redhat.com>
References: <4F3F1439.5000407@ubuntu.com> <4F3F1580.9020108@redhat.com> <20120218223131.GB8320@thunk.org> <B2C249E4-41BE-400F-BC11-B1F7ABDE308E@redhat.com> <20120220031938.GA5113@thunk.org> <4F4297FE.9090208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>, Eric Sandeen <esandeen@redhat.com>,
	Phillip Susi <psusi@ubuntu.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301Ab2BTTB5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Feb 2012 14:01:57 -0500
In-Reply-To: <4F4297FE.9090208@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/20/12 12:59 PM, Eric Sandeen wrote:
> On 2/19/12 9:19 PM, Ted Ts'o wrote:
>> On Sun, Feb 19, 2012 at 10:11:12PM -0500, Eric Sandeen wrote:
>>>> Which is in e2fsprogs 1.42.1....
>>>>
>>> Was that the release announcement?  :)
>>
>> I knew I forgot something.  :-)
>>
>> Over the weekend I released e2fsprogs 1.42.1.  It can be found in the
>> usual places: on sourceforge, a signed git tag, and on
>> ftp.kernel.org:/pub/linux/kernel/people/tytso/e2fsprogs/v1.42.1.
> 
> The tarball is a little messed up:
> 
> [esandeen@neon e2fsprogs]$ tar xvzf e2fsprogs-1.42.1.tar.gz
> e2fsprogs-libs-1.42.1/
> e2fsprogs-libs-1.42.1/.gitignore
> e2fsprogs-libs-1.42.1/.release-checklist
> e2fsprogs-libs-1.42.1/lib/
> 
> why does it unpack into e2fsprogs-libs-1.42.1?
>                                   ^^^^
> 
> I could work around that but it's unexpected.

Oh actually I can't work around it, it really is just the libs.

-Eric

