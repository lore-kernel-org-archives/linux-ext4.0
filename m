Return-Path: <SRS0=7vaa=OF=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail2.sequans.com ([194.98.51.148]:15614 "EHLO
        mail2.sequans.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbeK0AzU (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Nov 2018 19:55:20 -0500
Content-Type: multipart/mixed; boundary="===============5028384377000185114=="
MIME-Version: 1.0
To: <tytso@mit.edu>
Cc: <darrick.wong@oracle.com>, <linux-ext4@vger.kernel.org>
Subject: Re: Metadata_csum is still enabled after trying to disable it.
Message-Id: <E1gRHIO-0002Z8-4e@eureka>
From: Jean-Christophe Guillain <jcguillain@sequans.com>
Date: Mon, 26 Nov 2018 14:51:28 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--===============5028384377000185114==


----- On Nov 24, 2018, at 4:48 AM, Theodore Y. Ts'o tytso@mit.edu wrote:

​​​​​> On Wed, Nov 21, 2018 at 07:01:19PM -0800, Darrick J. Wong wrote:
>> > Is it a bug ?
>> 
>> Yes.
>> 
>> > How can I actually disable this parameter ?
>>
> 
> Actually, the metadata_csum feature *was* disabled.  You would have
> seen that if you looked at the "Features: " line printed by dumpe2fs
> -h or tune2fs -l.  The bug was that we were erroneously warning that
> the tune2fs -U operation would take a long time when flex_bg was
> enabled, but metadata_csum was not.  So it was misleading wrong, but
> it actually turning off the metadata_csum feature.
> 

Thank you very much for your time !

jC


--===============5028384377000185114==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable



-- IMPORTANT NOTICE: =


The contents of this email and any attachments are confidential and may als=
o be privileged. If you are not the intended recipient, please notify the s=
ender immediately and do not disclose the contents to any other person, use=
 it for any purpose, or store or copy the information in any medium. Thank =
you.

--===============5028384377000185114==--
