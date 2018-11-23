Return-Path: <SRS0=kdxW=OC=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail2.sequans.com ([194.98.51.148]:7616 "EHLO mail2.sequans.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388503AbeKXCTQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 23 Nov 2018 21:19:16 -0500
Content-Type: multipart/mixed; boundary="===============3032466536618801796=="
MIME-Version: 1.0
To: <darrick.wong@oracle.com>
Cc: <linux-ext4@vger.kernel.org>
Subject: Re: Metadata_csum is still enabled after trying to disable it.
Message-Id: <E1gQDKM-0004Pm-Ig@eureka>
From: Jean-Christophe Guillain <jcguillain@sequans.com>
Date: Fri, 23 Nov 2018 16:25:06 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--===============3032466536618801796==


​​​----- On Nov 22, 2018, at 4:01 AM, Darrick J. Wong darrick.wong@oracle.com wrote:
>> * I check : metadata checksum looks like disabled
>>     root@test# tune2fs -l /dev/my_vol tune2fs 1.43.4 (31-Jan-2017)
>>     Filesystem volume name:   <none>
>>     [...]
>>     Journal backup:           inode blocks
>> 
>> * I change filesystem UUID : It looks like metada checksum still is enabled
>>     root@test# tune2fs -U random /dev/my_vol
>>     tune2fs 1.43.4 (31-Jan-2017)
>>     Setting UUID on a checksummed filesystem could take some time.
>>     Proceed anyway (or wait 5 seconds) ? (y,N) y
>> 
>> Is it a bug ?
> 
> Yes.

Should I open a bug in bugzilla ?

> 
>> How can I actually disable this parameter ?
> 
> I think you have to turn off the metadata_csum_seed feature, but tbh
> tune2fs really shouldn't pester about !metadata_csum,metadata_csum_seed
> filesystems...
> 

I actually tried that (!metadata_csum,!metadata_csum_seed) : tune2fs has still the same behaviour.
How does it detect that the filesystem is (it shouldn't be anymore), or was checksummed ?

> --D
> 
>> Best regards,
>> jC Guillain
>> 
>> 

--===============3032466536618801796==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable



-- IMPORTANT NOTICE: =


The contents of this email and any attachments are confidential and may als=
o be privileged. If you are not the intended recipient, please notify the s=
ender immediately and do not disclose the contents to any other person, use=
 it for any purpose, or store or copy the information in any medium. Thank =
you.

--===============3032466536618801796==--
