From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [RFC] ext4_bmap() may return blocks outside filesystem
Date: Thu, 5 Feb 2009 17:01:01 -0500
Message-ID: <87f94c370902051401s6d73d810s720f187c134f0b1e@mail.gmail.com>
References: <498AD58B.5000805@ph.tum.de> <20090205134905.GL8945@mit.edu>
	 <87f94c370902050722wf2099c9i2d815737e85209f3@mail.gmail.com>
	 <498B084F.2060608@redhat.com> <20090205164803.GM8945@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Thiemo Nagel <thiemo.nagel@ph.tum.de>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:31473 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbZBEWBD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Feb 2009 17:01:03 -0500
Received: by qw-out-2122.google.com with SMTP id 3so263302qwe.37
        for <linux-ext4@vger.kernel.org>; Thu, 05 Feb 2009 14:01:01 -0800 (PST)
In-Reply-To: <20090205164803.GM8945@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 5, 2009 at 11:48 AM, Theodore Tso <tytso@mit.edu> wrote:
> On Thu, Feb 05, 2009 at 10:39:59AM -0500, Ric Wheeler wrote:
>> Greg Freemyer wrote:
>>> This is just a rant, and I doubt anyone can do anything about it, but
>>> it is still worth reading imho.
>
> It also has absolutely nothing to do with the original thread, which
> was block numbers which are far outside the range of valid block
> numbers given the size of the block device.  :-)
>

The subject was "return blocks outside filesystem".

In a thin-provisioning environment I'd argue that unmapped sectors are
"outside the filesystem". :)

Unfortunately, I can't get anyone else to see the world from my
apparently unique perspective. :(
