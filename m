From: "U.Mutlu" <for-gmane@mutluit.com>
Subject: Re: generic question: user-only directory w/o root access
Date: Thu, 4 Jun 2015 15:24:06 +0200
Message-ID: <mkpjhm$7i5$1@ger.gmane.org>
References: <mkfbkb$fo1$1@ger.gmane.org> <20150531185934.GE11642@thunk.org>
 <mkg2u2$ckm$1@ger.gmane.org> <20150604014452.GA5759@thunk.org>
 <alpine.LFD.2.00.1506041323280.32156@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57423 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617AbbFDNYm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Jun 2015 09:24:42 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1Z0V8D-0002JW-M0
	for linux-ext4@vger.kernel.org; Thu, 04 Jun 2015 15:24:25 +0200
Received: from ip4d178d5f.dynamic.kabel-deutschland.de ([77.23.141.95])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Thu, 04 Jun 2015 15:24:25 +0200
Received: from for-gmane by ip4d178d5f.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Thu, 04 Jun 2015 15:24:25 +0200
In-Reply-To: <alpine.LFD.2.00.1506041323280.32156@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Luk=C3=A1=C5=A1 Czerner wrote on 06/04/2015 01:29 PM:
> On Wed, 3 Jun 2015, Theodore Ts'o wrote:
>
>> Date: Wed, 3 Jun 2015 21:44:52 -0400
>> From: Theodore Ts'o <tytso@mit.edu>
>> To: U.Mutlu <for-gmane@mutluit.com>
>> Cc: linux-ext4@vger.kernel.org
>> Subject: Re: generic question: user-only directory w/o root access
>>
>> On Mon, Jun 01, 2015 at 12:45:22AM +0200, U.Mutlu wrote:
>>> A private directory (or private mountpoint) for the user only
>>> (or for an application running under that 'user'-account).
>>>
>>> The rationale behind this is: there are many system programs,
>>> and other programs running with root rights. The user cannot know
>>> them all and so cannot trust them. This includes also admins and th=
e root
>>> user itself.
>>>
>>> The idea is to have a truly private directory or a private mountpoi=
nt
>>> where by default nobody else has access to it, incl. root,
>>> unless the owner grants access to others.
>>
>> A user can't protect herself from root.  For one thing, root can
>> modify the kernel, or install a module that runs arbitrary code insi=
de
>> the kernel context.  If you can insert or run arbitrary kernel code,
>> you can do *anything*.  You can extract the user's encryption key; y=
ou
>> can mess with arbitrary namespaces.  Root can use ptrace to muck wit=
h
>> a running process.  Etc., etc., etc.
>>
>>> So, my wish is to mount an encrypted virtual HD to a mountpoint,
>>> and nobody else shall have access to it, especially not root or
>>> any program with root rights.
>>>
>>> Does anybody know of such an open-source solution for Linux?
>>
>> No, just as there is no open-source solution for a perpetual motion
>> machine...
>>
>> Ultimately, the user has to trust the hardware and the firmware on i=
t,
>> the kernel, root, whoever is building the kernel (i.e., if you are
>> using Debian and using the Debian kernel, you have to trust the peop=
le
>> who build the Debian kernel, the Debian ftpmasters and so on).
>>
>>      	      	     	     	 		   - Ted
>
> Everything Ted mentioned is true. However there are ways to prevent
> application and daemons running under root privileges doing harmful
> things. Using Selinux is one of the ways
> (https://en.wikipedia.org/wiki/Security-Enhanced_Linux).
>
> However note that it'll still require you to trust your hardware,
> kernel, whoever has a root access and to some extent the
> applications as well because since it will protect you from someone
> exploiting a bug in the application it will not fully protect you
> from intentionally malicious application (because again, as a root
> user you *can* do anything).

Hello Ted, Lukas, and All,

please don't get me wrong, I know how these things work.
My security concern is against possible trojans on the server
and online criminals using social engineering etc.

The said special security requirement is for a special high-security=20
application. The customer files (encryped mails, cust db etc.)
has to be secured against online thiefs and for example against
NSA trojans maybe implanted thru "official" channels like is the
case with Adobe and Microsoft, everybody knows that...

I use a truecrypt container with ext2 on it and now use the mentioned
private namespace-mount, because only that single application (running
under its own user account) shall have access to the mountpoint,
root by default has no access to it, and yes as you both pointed out
root can overcome this, but then he would need to restart the machine.
But then he cannot mount the encrypted volume :-) [not using any automo=
unt],
so, imo that solution looks to me rock solid, and that was what I was
looking for when I started the thread here.

--=20
Thx
Uenal



--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
