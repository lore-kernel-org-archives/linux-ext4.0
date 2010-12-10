From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH 1/2] ext2: speed up file creates by optimizing rec_len functions
Date: Fri, 10 Dec 2010 16:40:41 -0700
Message-ID: <68AB6BC2-4F3F-46E6-AF17-E26FCB03EE9D@dilger.ca>
References: <4CFE7347.8030807@redhat.com> <4CFE7409.9090609@redhat.com> <20101207130708.71c894e9.akpm@linux-foundation.org> <4CFEA5AF.2000702@redhat.com> <20101207133308.eb2144da.akpm@linux-foundation.org> <63DB7A38-7D0F-406E-8ACD-9CE5DB977DD9@dilger.ca> <4CFFF394.1020303@redhat.com> <F51EB2BF-8C99-4E2F-943E-E795A0F4DF7F@dilger.ca> <4D002B91.7020409@redhat.com> <20101210175549.GC3059@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:12230 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575Ab0LJXkn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Dec 2010 18:40:43 -0500
In-Reply-To: <20101210175549.GC3059@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-12-10, at 10:55, Ted Ts'o wrote:
> On Wed, Dec 08, 2010 at 08:06:25PM -0500, Ric Wheeler wrote:
>> If we could get rid of ext2 (and eventually ext3), it would actually
>> help reduce the testing matrix and possibly let us invest even more
>> in testing ext4.  Having to maintain three very similar code bases
>> and test them all for correctness and performance is a real pain :)
> 
> A distribution can do that at any time, just by unconfiguring
> CONFIG_EXT2 and/or CONFIG_EXT3 and configuring
> CONFIG_EXT4_USE_FOR_EXT23.   :-)

That doesn't get rid of the maintenance efforts, however.  There are a
constant stream of "patch for ext[234] needs to be ported to ext[342]".

Cheers, Andreas





