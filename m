From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
Subject: Re: Mentor for a GSoC application wanted (Online ext2/3 filesystem checker)
Date: Mon, 21 Apr 2008 04:27:19 +0400
Message-ID: <f19298770804201727w37d4f37fs91940caca5d24ad3@mail.gmail.com>
References: <f19298770804180720w2e72b821j95b709c1dd1b1c25@mail.gmail.com>
	 <20080419012952.GE25797@mit.edu>
	 <f19298770804190244y5d6a8502p39f98d1c420135a@mail.gmail.com>
	 <20080419185603.GA30449@mit.edu> <480A42F6.2030005@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: "Theodore Tso" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, "Rik van Riel" <riel@surriel.com>
To: "Eric Sandeen" <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:39703 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbYDUA1U (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 20 Apr 2008 20:27:20 -0400
Received: by wa-out-1112.google.com with SMTP id m16so2692934waf.23
        for <linux-ext4@vger.kernel.org>; Sun, 20 Apr 2008 17:27:19 -0700 (PDT)
In-Reply-To: <480A42F6.2030005@redhat.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 19, 2008 at 11:07 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> Theodore Tso wrote:
>  > On Sat, Apr 19, 2008 at 01:44:51PM +0400, Alexey Zaytsev wrote:
>  >> If it is a block containing a metadata object fsck has already read,
>  >> than we already know what kind of object it is (there must be a way
>  >> to quickly find all cached objects derived from a given block), and
>  >> can update the cached version. And if fsck has not yet read the
>  >> block, it can just be ignored, no matter what kind of data it
>  >> contains. If it contains metadata and fsck is intrested in it, it
>  >> will read it sooner or later anyway. If it contains file data, why
>  >> should fsck even care?
>
>  It seems to me that what the proposed project really does, in essence,
>  is a read-only check of a filesystem snapshot.  It's just that the
>  snapshot is proposed to be constructed in a complex and non-generic (and
>  maybe impossible) way.

Maybe complex and non-generic, but also quite efficient. Only the actually used
matadata is cached, and everything is done in userspace.

>
>  If you really just want to verify a snapshot of the fs at a point in
>  time, surely there are simpler ways.  If the device is on lvm, there's
>  already a script floating around to do it in automated fasion.  (I'd
>  pondered the idea of introducing META_WRITE (to go with META_READ) and
>  maybe lvm could do a "metadata-only" snapshot to be lighter weight?)

How do you tell data from metadata on this level?

>
>  -Eric
>
