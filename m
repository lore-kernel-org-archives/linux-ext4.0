From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v2 10/10] ext4: use memweight()
Date: Sun, 3 Jun 2012 21:57:42 +0900
Message-ID: <CAC5umyhJ1mCGHE6i61MKOMr4RxVAh_wUFDWUEPsdtK_rC-o4=A@mail.gmail.com>
References: <1338644416-11417-1-git-send-email-akinobu.mita@gmail.com>
	<1338644416-11417-10-git-send-email-akinobu.mita@gmail.com>
	<B6D8D29B-9D9E-4248-B1EE-703D46354522@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:55714 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab2FCM5n (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 3 Jun 2012 08:57:43 -0400
In-Reply-To: <B6D8D29B-9D9E-4248-B1EE-703D46354522@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2012/6/2 Andreas Dilger <adilger@dilger.ca>:
> On 2012-06-02, at 7:40, Akinobu Mita <akinobu.mita@gmail.com> wrote:
>
>> Use memweight() to count the total number of bits clear in memory area.
>> This change only affects the code segments enabled by EXT4FS_DEBUG.
>
> Personally, I'd rather still keep a thin wrapper ext4_count_free() and put the memweight() call and math inside that. The function name ext4_count_free() is meaningful to readers, while memweight() is much less so.

OK, I'll make such change to ext[234] if no other people disagree with it.
