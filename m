From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfstests 224: test aio hole-fill at 4g
Date: Sat, 30 Jan 2010 13:46:10 -0600
Message-ID: <4B648C82.3040801@sandeen.net>
References: <4B633F9A.8000404@sandeen.net> <20100130105501.GA22909@infradead.org> <4B645B0D.205@sandeen.net> <20100130172502.GA788@thunk.org> <4B647AFE.5000507@sandeen.net> <20100130191113.GC10181@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, ext4 development <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>, Giel de Nijs <giel@vectorwise.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 64-131-60-146.usfamily.net ([64.131.60.146]:37558 "EHLO
	mail.sandeen.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab0A3TqL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 30 Jan 2010 14:46:11 -0500
In-Reply-To: <20100130191113.GC10181@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Christoph Hellwig wrote:
> On Sat, Jan 30, 2010 at 12:31:26PM -0600, Eric Sandeen wrote:
>> These are the deps that I know xfstests has, to build and to run:
>>
>> BuildRequires:  autoconf, libtool, xfsprogs-devel, e2fsprogs-devel
>> BuildRequires:  libacl-devel, libattr-devel, libaio-devel
>>
>> Requires:       bash, xfsprogs, xfsdump, perl, acl, attr, bind-utils
>> Requires:       bc, indent, quota
>>
>> which isn't so bad...
> 
> Doesn't seem to bad.  Indent is afaik only needed for the weird 122 test
> which doesn't apply to non-xfs filesystems.

and FWIW, we do:

_require_command /usr/bin/indent

so it'll just not run if it's not there (the above was for an rpm
attempt I made, wishing to automatically pull in everything that
might possibly be needed.)

-Eric

>> I'm not sure an xfsprogs dependency is so onerous; plenty has depended
>> on e2fsprogs through the years and we've lived with that ;)  But
>> the lag time for xfsprogs to use released xfs_io functionality is a
>> bit of a bummer.
>>
>> But I guess I don't have a great answer for who else uses xfs_io:
> 
> I use xfs_io in lots various local scripts.  It's a really handly
> tool for exercising some of the more weird I/O related syscalls.
> 

