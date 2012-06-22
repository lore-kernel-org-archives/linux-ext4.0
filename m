From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: Ext4 slow on links
Date: Fri, 22 Jun 2012 11:53:13 +0200
Message-ID: <4FE44089.2010609@fastmail.fm>
References: <20120620051844.GA7829@gamma.logic.tuwien.ac.at> <4FE1D993.8090307@redhat.com> <20120620002014.GA25471@gamma.logic.tuwien.ac.at> <4FE14034.6070800@redhat.com> <20120620002014.GA25471@gamma.logic.tuwien.ac.at> <20120620021912.GA26323@thunk.org> <20120620033831.GA2395@gamma.logic.tuwien.ac.at> <BA050E9A-2385-4FF9-B41A-3A25F3FF066A@redhat.com> <20120620051844.GA7829@gamma.logic.tuwien.ac.at> <4FE1D91B.8020707@redhat.com> <20120621022818.GD9669@gamma.logic.tuwien.ac.at> <4FE29DA7.40405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Norbert Preining <preining@logic.at>, "Ted Ts'o" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:48740 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761923Ab2FVJxT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Jun 2012 05:53:19 -0400
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id q5M9rH5m012751
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Fri, 22 Jun 2012 11:53:17 +0200
In-Reply-To: <4FE29DA7.40405@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/21/2012 06:05 AM, Eric Sandeen wrote:
> On 6/20/12 9:28 PM, Norbert Preining wrote:
>> Hi Eric,
>>
>
> You could see if you could get this LD_PRELOAD working:
>
> http://git.kernel.org/?p=fs/ext2/e2fsprogs.git;a=blob_plain;f=contrib/spd_readdir.c
>

Hrmm, I need to look through that commit again, but on a first glance I 
cannot see code doing the sorting for ext3/ext4 only (e.g. by checking 
the fsid). So while I like the general approach, it will have the 
opposite effect for some file systems. I will report that back on the 
coreutils list.

Thanks a lot for the pointer to the commit!


Cheers,
Bernd

