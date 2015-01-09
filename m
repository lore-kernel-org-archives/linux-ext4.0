From: Eric Sandeen <esandeen@redhat.com>
Subject: Re: Can one file system be R/W mounted multiple times in Linux?
Date: Fri, 9 Jan 2015 01:04:36 -0500 (EST)
Message-ID: <E09EF4B0-81D8-445C-B921-F920336200AC@redhat.com>
References: <F792CF86EFE20D4AB8064279AFBA51C61EA72765@SIXPRD3002MB028.064d.mgd.msft.net> <20150109035123.GG22149@ZenIV.linux.org.uk> <F792CF86EFE20D4AB8064279AFBA51C61EA727DE@SIXPRD3002MB028.064d.mgd.msft.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	"stefanha@redhat.com" <stefanha@redhat.com>
To: Dexuan Cui <decui@microsoft.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <F792CF86EFE20D4AB8064279AFBA51C61EA727DE@SIXPRD3002MB028.064d.mgd.msft.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jan 8, 2015, at 10:59 PM, Dexuan Cui <decui@microsoft.com> wrote:

>> -----Original Message-----
>> From: Al Viro [mailto:viro@ftp.linux.org.uk] On Behalf Of Al Viro
>> Sent: Friday, January 9, 2015 11:51 AM
>> To: Dexuan Cui
>> Cc: linux-fsdevel@vger.kernel.org; 'linux-ext4'; stefanha@redhat.com
>> Subject: Re: Can one file system be R/W mounted multiple times in Linux?
>> 
>>> On Fri, Jan 09, 2015 at 03:44:16AM +0000, Dexuan Cui wrote:
>>> The 'mount' utility allows me to mount 1 file systems multiple times at
>> different
>>> mount points, like "mount /dev/sdb1 /a; mount /dev/sdb1 /b".
>>> 
>>> I tried to write from /a and /b at the same time and it seems everything is OK
>>> and no data corruption happens.
>>> I tried only  ext4 only.
>>> 
>>> Can somebody please tell me if this usage is safe?
>> 
>> Yes.
> 
> Thanks for the confirmation!
> 
> -- Dexuan

But to be clear, just in case - this is completely different from, say, mounting the same ext4 fs on two different nodes on a SAN, which is quite certainly not safe...

-Eric