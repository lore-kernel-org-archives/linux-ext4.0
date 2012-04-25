From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 5 2/4] Return 32/64-bit dir name hash according to usage
 type
Date: Wed, 25 Apr 2012 10:05:43 -0500
Message-ID: <4F9812C7.3020300@redhat.com>
References: <20120109132137.2616029.76288.stgit@localhost.localdomain> <20120109132148.2616029.68798.stgit@localhost.localdomain> <4F91C15B.6070200@redhat.com> <4F93FED6.6090505@itwm.fraunhofer.de> <4F95BD72.6090200@redhat.com> <4F95C109.1030401@itwm.fraunhofer.de> <4F95D65A.8070608@redhat.com> <A754D23B-B946-4E80-ACEA-0E2C2E6FAA2E@whamcloud.com> <4F96D08B.2020606@itwm.fraunhofer.de> <4F96FD45.9080902@redhat.com> <4F971602.7090005@itwm.fraunhofer.de> <C53AC043-C67D-44DD-9A11-3A196627668A@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
	linux-ext4@vger.kernel.org, Fan Yong <yong.fan@whamcloud.com>,
	bfields@redhat.com
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736Ab2DYPFt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Apr 2012 11:05:49 -0400
In-Reply-To: <C53AC043-C67D-44DD-9A11-3A196627668A@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/24/12 5:24 PM, Andreas Dilger wrote:
> On 2012-04-24, at 4:07 PM, Bernd Schubert wrote:
>>> 1) For SEEK_END, we now return -EINVAL for a positive offset (i.e. past EOF)
>>
>> I definitely introduces that one, as I cannot see how an application
>> might ever run into it. Especially as ext4 directories cannot shrink. So
>> if an application tries to exceed the directory size limit, it looks to
>> me as some of attempt to break something or as an error in the
>> application. However, if there should be the slightest chance to break
>> existing applications relying on that, we need to remove that.
> 
> I think the other reason to avoid SEEK_END + n is that since SEEK_END
> for a hash offset is (signed) MAX_LONG, so if one seeks beyond that
> it will wrap to a negative offset.

Makes sense.

Wishing this had been done as a separate patch, though, since it's really addressing a separate issue from the $SUBJECT, and could have used specific documentation of the change.  Nitpicky I know, but it helps.

-Eric

> Cheers, Andreas
> --
> Andreas Dilger                       Whamcloud, Inc.
> Principal Lustre Engineer            http://www.whamcloud.com/
> 
> 
> 
> 

