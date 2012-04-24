From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH 5 2/4] Return 32/64-bit dir name hash according to usage type
Date: Tue, 24 Apr 2012 17:24:51 -0500
Message-ID: <C53AC043-C67D-44DD-9A11-3A196627668A@whamcloud.com>
References: <20120109132137.2616029.76288.stgit@localhost.localdomain> <20120109132148.2616029.68798.stgit@localhost.localdomain> <4F91C15B.6070200@redhat.com> <4F93FED6.6090505@itwm.fraunhofer.de> <4F95BD72.6090200@redhat.com> <4F95C109.1030401@itwm.fraunhofer.de> <4F95D65A.8070608@redhat.com> <A754D23B-B946-4E80-ACEA-0E2C2E6FAA2E@whamcloud.com> <4F96D08B.2020606@itwm.fraunhofer.de> <4F96FD45.9080902@redhat.com> <4F971602.7090005@itwm.fraunhofer.de>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	Fan Yong <yong.fan@whamcloud.com>, bfields@redhat.com
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51486 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757146Ab2DXWNd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Apr 2012 18:13:33 -0400
Received: by obbta14 with SMTP id ta14so1750581obb.19
        for <linux-ext4@vger.kernel.org>; Tue, 24 Apr 2012 15:13:33 -0700 (PDT)
In-Reply-To: <4F971602.7090005@itwm.fraunhofer.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-04-24, at 4:07 PM, Bernd Schubert wrote:
>> 1) For SEEK_END, we now return -EINVAL for a positive offset (i.e. past EOF)
> 
> I definitely introduces that one, as I cannot see how an application
> might ever run into it. Especially as ext4 directories cannot shrink. So
> if an application tries to exceed the directory size limit, it looks to
> me as some of attempt to break something or as an error in the
> application. However, if there should be the slightest chance to break
> existing applications relying on that, we need to remove that.

I think the other reason to avoid SEEK_END + n is that since SEEK_END
for a hash offset is (signed) MAX_LONG, so if one seeks beyond that
it will wrap to a negative offset.

Cheers, Andreas
--
Andreas Dilger                       Whamcloud, Inc.
Principal Lustre Engineer            http://www.whamcloud.com/




