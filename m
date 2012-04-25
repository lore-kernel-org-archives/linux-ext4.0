From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: Re: [PATCH 5 2/4] Return 32/64-bit dir name hash according to usage
 type
Date: Wed, 25 Apr 2012 17:12:24 +0200
Message-ID: <4F981458.1010708@itwm.fraunhofer.de>
References: <20120109132137.2616029.76288.stgit@localhost.localdomain> <20120109132148.2616029.68798.stgit@localhost.localdomain> <4F91C15B.6070200@redhat.com> <4F93FED6.6090505@itwm.fraunhofer.de> <4F95BD72.6090200@redhat.com> <4F95C109.1030401@itwm.fraunhofer.de> <4F95D65A.8070608@redhat.com> <A754D23B-B946-4E80-ACEA-0E2C2E6FAA2E@whamcloud.com> <4F96D08B.2020606@itwm.fraunhofer.de> <4F96FD45.9080902@redhat.com> <4F971602.7090005@itwm.fraunhofer.de> <C53AC043-C67D-44DD-9A11-3A196627668A@whamcloud.com> <4F9812C7.3020300@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@whamcloud.com>, linux-ext4@vger.kernel.org,
	Fan Yong <yong.fan@whamcloud.com>, bfields@redhat.com
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:49973 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab2DYPM3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Apr 2012 11:12:29 -0400
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id q3PFCRO0021188
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Wed, 25 Apr 2012 17:12:27 +0200
In-Reply-To: <4F9812C7.3020300@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/25/2012 05:05 PM, Eric Sandeen wrote:
> On 4/24/12 5:24 PM, Andreas Dilger wrote:
>> On 2012-04-24, at 4:07 PM, Bernd Schubert wrote:
>>>> 1) For SEEK_END, we now return -EINVAL for a positive offset (i.e. past EOF)
>>>
>>> I definitely introduces that one, as I cannot see how an application
>>> might ever run into it. Especially as ext4 directories cannot shrink. So
>>> if an application tries to exceed the directory size limit, it looks to
>>> me as some of attempt to break something or as an error in the
>>> application. However, if there should be the slightest chance to break
>>> existing applications relying on that, we need to remove that.
>>
>> I think the other reason to avoid SEEK_END + n is that since SEEK_END
>> for a hash offset is (signed) MAX_LONG, so if one seeks beyond that
>> it will wrap to a negative offset.
>
> Makes sense.
>
> Wishing this had been done as a separate patch, though, since it's really addressing a separate issue from the $SUBJECT, and could have used specific documentation of the change.  Nitpicky I know, but it helps.

Sorry, my fault. Maybe we should simply document it in the code?
And how do we proceed in general. Shall I write a patch to use 
generic_file_llseek() and update that function to take more arguments? I 
don't think that would go into 3.4.

Thanks,
Bernd
