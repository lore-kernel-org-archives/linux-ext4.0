From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Mentor for a GSoC application wanted (Online ext2/3 filesystem
 checker)
Date: Sat, 19 Apr 2008 14:07:34 -0500
Message-ID: <480A42F6.2030005@redhat.com>
References: <f19298770804180720w2e72b821j95b709c1dd1b1c25@mail.gmail.com> <20080419012952.GE25797@mit.edu> <f19298770804190244y5d6a8502p39f98d1c420135a@mail.gmail.com> <20080419185603.GA30449@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Alexey Zaytsev <alexey.zaytsev@gmail.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Rik van Riel <riel@surriel.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754349AbYDSTJk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 19 Apr 2008 15:09:40 -0400
In-Reply-To: <20080419185603.GA30449@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Sat, Apr 19, 2008 at 01:44:51PM +0400, Alexey Zaytsev wrote:
>> If it is a block containing a metadata object fsck has already read,
>> than we already know what kind of object it is (there must be a way
>> to quickly find all cached objects derived from a given block), and
>> can update the cached version. And if fsck has not yet read the
>> block, it can just be ignored, no matter what kind of data it
>> contains. If it contains metadata and fsck is intrested in it, it
>> will read it sooner or later anyway. If it contains file data, why
>> should fsck even care?

It seems to me that what the proposed project really does, in essence,
is a read-only check of a filesystem snapshot.  It's just that the
snapshot is proposed to be constructed in a complex and non-generic (and
maybe impossible) way.

If you really just want to verify a snapshot of the fs at a point in
time, surely there are simpler ways.  If the device is on lvm, there's
already a script floating around to do it in automated fasion.  (I'd
pondered the idea of introducing META_WRITE (to go with META_READ) and
maybe lvm could do a "metadata-only" snapshot to be lighter weight?)

-Eric
