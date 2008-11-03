From: Olaf Weber <olaf@infovore.xs4all.nl>
Subject: Re: [PATCH,RFC] ext3: Add support for non-native signed/unsigned htree hash algorithms
Date: Mon, 03 Nov 2008 08:33:34 +0100
Message-ID: <87zlkhb6wh.fsf@infovore.xs4all.nl>
References: <1224560624-9691-1-git-send-email-tytso@mit.edu>
	<1224560624-9691-2-git-send-email-tytso@mit.edu>
	<20081022172221.c1a8c5b5.akpm@linux-foundation.org>
	<20081023025646.GD10369@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1233 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691AbYKCHmg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Nov 2008 02:42:36 -0500
In-Reply-To: <20081023025646.GD10369@mit.edu> (Theodore Tso's message of "Wed, 22 Oct 2008 22:56:47 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso writes:
> On Wed, Oct 22, 2008 at 05:22:21PM -0700, Andrew Morton wrote:

>> > +		if (((int) c) == -1) {
>> 
>> arm says
>> 
>> fs/ext3/super.c: In function `ext3_fill_super':
>> fs/ext3/super.c:1750: warning: comparison is always false due to limited range of data type
>> 
>> Also, is there any way in which this new code can be, umm, cleaned up?

> Hmm..... is it considered safe to depend on the userspace limits.h
> header file?  I guess if we trust that header file to be correct we
> could check the value of CHAR_MIN and/or CHAR_MAX as defined by
> limits.h.

> Alternatively we could do an #ifdef __CHAR_UNSIGNED__, which is
> defined by gcc.  The manual for gcc tells us not to depend on it, but
> to depend on limits.h instead.

> Any thoughts, or comments?  Does anyone know if the Intel compiler
> will DTRT with either of these approaches?

Why not write the test like this?

	if ((char)-1 > 0) {
		/* char is unsigned */
	} else {
		/* char is signed */
	}

-- 
Olaf Weber
