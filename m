From: "U.Mutlu" <for-gmane@mutluit.com>
Subject: Re: generic question: user-only directory w/o root access
Date: Fri, 5 Jun 2015 21:24:51 +0200
Message-ID: <mkst24$nbb$1@ger.gmane.org>
References: <mkfbkb$fo1$1@ger.gmane.org> <20150531185934.GE11642@thunk.org>
 <mkg2u2$ckm$1@ger.gmane.org> <20150604014452.GA5759@thunk.org>
 <alpine.LFD.2.00.1506041323280.32156@localhost.localdomain>
 <mkpjhm$7i5$1@ger.gmane.org> <20150605141429.GA26550@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49164 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbbFETZ7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Jun 2015 15:25:59 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1Z0xEw-0000aU-TW
	for linux-ext4@vger.kernel.org; Fri, 05 Jun 2015 21:25:14 +0200
Received: from ip4d178d5f.dynamic.kabel-deutschland.de ([77.23.141.95])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 05 Jun 2015 21:25:14 +0200
Received: from for-gmane by ip4d178d5f.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 05 Jun 2015 21:25:14 +0200
In-Reply-To: <20150605141429.GA26550@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote on 06/05/2015 04:14 PM:
> On Thu, Jun 04, 2015 at 03:24:06PM +0200, U.Mutlu wrote:
>> I use a truecrypt container with ext2 on it and now use the mentioned
>> private namespace-mount, because only that single application (running
>> under its own user account) shall have access to the mountpoint,
>> root by default has no access to it, and yes as you both pointed out
>> root can overcome this, but then he would need to restart the machine.
>> But then he cannot mount the encrypted volume :-) [not using any automount],
>> so, imo that solution looks to me rock solid, and that was what I was
>> looking for when I started the thread here.
>
> I wouldn't count out a sufficiently clever root user.  At the very
> minimum, root could replace the kernel and wait for the system to
> reboot under normal circumstances.  The root user could load a kernel
> module (or replace an existing kernel module) that gives him access to
> *any* namespace, or extract *any* key, or read from *any* userspace
> process.
>
> If there are any shared files used by both the container and rest of
> the system (i.e., if the container only contains the data files and
> uses /usr/bin and /bin and /lib from the rest of the system), then
> root could replace one of these executables or shared libaries which
> would then used by the container.  If you are using kvm in the
> "secure" container, root could insert mailware into the kvm binary.
>
> If you are using a secure boot system (i.e., using UEFI bios with your
> own firmware public/private key pair), and then use a kernel signed by
> your BIOS key, and then use signed modules, and then use SELinux to
> try to add more fences to prevent unauthorized changes to binaries,
> you can make things more secure.
>
> But your original statement talked about trying to protect against all
> root users, and that's what was so concerning.  Listing all of the
> authorized users may very well be a very large list.  Consider that on
> a Debian system, this includes all of the people authorized to upload
> packages to the debian-security repository (or the equivalent for
> Fedora, SuSE, etc.)
>
> This is why a lot of people who hear words like "rock solid" will
> start assuming that the speaker either doesn't know what he or she is
> talking about, and/or is a snake oil salesperson.  :-)
>
> Regards,
>
> 						- Ted

Dear Ted,
true, the dangers and challenges are high. The solution I finally
found took me unfortunately a long time to find it, and I know of
no other open-source solution to achieve what I described,
because of the unfortunate 'root is king and user is nobody' mentality
and reality we have.
But as described, in some security environments the user needs
a truly private space on the system where nobody else has access to.

I'm just a concerned admin seeking a practical solution to
the challenging problem IMO we all face nowadays regarding
data security and integrity.

If you have any other or further ideas on how such a security goal
could be realized or improved upon under a stock Linux distribution,
let me know pls, I'm open for all suggestions.

I think the filesystem could indeed implement such a "user-only" directory,
because the FUSE-API wrapper showed me that it is indeed possible
to implement that idea. I would suggest to add this feature to ext4,
and that new feature could be a real game-changer (yes, I know another
bold statement) in IT security.

Thx
Uenal


