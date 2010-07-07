From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: inconsistent file placement
Date: Tue, 06 Jul 2010 21:29:53 -0500
Message-ID: <4C33E6A1.7090408@redhat.com>
References: <469D2D911E4BF043BFC8AD32E8E30F5B24AED8@wdscexbe07.sc.wdc.com> <20100706185548.GA26677@thunk.org> <4C337D16.9000200@redhat.com> <469D2D911E4BF043BFC8AD32E8E30F5B24AEDB@wdscexbe07.sc.wdc.com> <20100706231412.GA7646@thunk.org> <469D2D911E4BF043BFC8AD32E8E30F5B24AEDF@wdscexbe07.sc.wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, amir73il@gmail.com, linux-ext4@vger.kernel.org
To: Daniel Taylor <Daniel.Taylor@wdc.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907Ab0GGCaB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Jul 2010 22:30:01 -0400
In-Reply-To: <469D2D911E4BF043BFC8AD32E8E30F5B24AEDF@wdscexbe07.sc.wdc.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Daniel Taylor wrote:
>> -----Original Message-----
>> From: tytso@mit.edu [mailto:tytso@mit.edu] 
...

 
>> Speaking of fallocate.... if this is a NAS box than the file is
>> probably written using CIFS, right?  Are you using a modern version of
>> Samba?  
> 
> Currently, we're on 3.2.5 of smdb, but that's because the later versions
> work less well with ext3.  We will be testing them with ext4 now that
> we see the other options it offers.
> 
> Soon as I can get the fallocate utility cross-built, there are some
> experiments that I want to run, but those will take a couple of days.
> 
> Thanks again for all of your help.

http://sandeen.fedorapeople.org/utilities/fallocate.c

should be a simple compilable utility, or if for some reason
you don't have it in your glibc, you can call the syscall directly
with:

http://sandeen.fedorapeople.org/utilities/fallocate-via-syscall.c

(you may need to define SYS_fallocate & massage appropriately
depending on the architecture)

The tool in util-linux-ng is similar, and I think started with
this code, but its a quick hack so look out for bugs ;)

-Eric
