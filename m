Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABFA384CD5;
	Wed,  3 Jun 2026 14:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780496535; cv=none; b=TqPu4TxhGzqyh8lOzWMjtyky4a6zVaU1rzPnXkUsm8oOovt6fMBERY+wPWPu7ugQcoZiGthaWMLwTckMSd3lvLCuR7tO/plW2KKFuQurwV4Nk9b5PgxcZ+JP0ed0UMJ9ZB/GgSjK0CZGlGlhpncGB4nAywMHWmXJZ7/rqCyHrnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780496535; c=relaxed/simple;
	bh=0F7lSWbl72eLZVoxDY3NwkyG+Pw9QVACrJjV+kf2M9o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zu2ChT76xg0wyWYvpO8Gcx7nJkYZ9eiCwA7h0FkIMcjGQMCeu/HaqnlZ5uWi4BIW6XeCcu1M0vCI8Col28g3eXoYL03jZ8NFaJYPNBDw2o2l+qUm8kFX8vrvDWX2Zn+oya0IHswHK6OBQDraz2B1bDV13N2gIpEG4sXL17GqDrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ZkHK5DS8; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZkHK5DS8"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 653DalrR3717409;
	Wed, 3 Jun 2026 14:22:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=b582ol
	g0TX9vthSeQh4035CtgTh4gbaT5F6jCx/S3po=; b=ZkHK5DS8flDEE8EBqLWeMh
	8v6Xrh4ouT3EZRRH06bwPq108pgbB3mz597QCUYKEjFqZMd2+jM8/9cRm3T5NexI
	vFZnipuvQLouEu0TY5vMggubot0mFzPvDnnK9MA7Wg7E3Xcw9fc6zA903xa20Re3
	sG2DJ0v841jHOdTAk/K5VQFM22xxhqL91jwjCRnoPa3+ug1yj9yeT9/pYIpWk2h0
	rolc2rYPPwFg6gjaxppUpIEbMP0zcW9EdauywLuoN9HDcf7JpuxcKJx0muctetNx
	8SYQB1FkOl8Tt7aY+Ma9hu6OoejJe8ypWSPWa3AQVxwXBGhuYES/BJMtidhJFiKg
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4efnahty82-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 Jun 2026 14:22:12 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 653E9CPJ028318;
	Wed, 3 Jun 2026 14:22:12 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4egbqhgekc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 Jun 2026 14:22:11 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 653EM9HH61014318
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 3 Jun 2026 14:22:10 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CEA832004E;
	Wed,  3 Jun 2026 14:22:08 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 92AC520049;
	Wed,  3 Jun 2026 14:22:07 +0000 (GMT)
Received: from [9.124.223.193] (unknown [9.124.223.193])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  3 Jun 2026 14:22:07 +0000 (GMT)
Message-ID: <6de4cd30-509a-4d4e-b715-46ed941e9295@linux.ibm.com>
Date: Wed, 3 Jun 2026 19:52:06 +0530
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] common/defrag: Skip defrag tests on DAX-enabled
 filesystems
Content-Language: en-GB
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ritesh.list@gmail.com
References: <20260602101418.55131-1-disgoel@linux.ibm.com>
 <ah6yl1T9jnN0wH6d@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
From: Disha Goel <disgoel@linux.ibm.com>
In-Reply-To: <ah6yl1T9jnN0wH6d@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAzMDEzNiBTYWx0ZWRfX/sb00G5T1wZy
 C9xDPj4dra/b0uVWK956NnREbAESu8dCQYmzgxlDZTWmD8vRhiieLZbWWU0+5Om8avylp8xNBRZ
 NCt157cfPcu91iqYXil62oZ+QPy+40sbv/eyQohYKkxLl2FEVUAMg1Lfr0Qa9iSJr3AhGn1iH0c
 MukKWAoaz+PafUxYxl5kiDTvK/Exv77dP8VlubOPKcYO7sQ//KGQKbFK1jNJ7UkGFiRLoV8gtkj
 taTMVuZ8HS9DWBPpjqYUwU0zevYnYbHqP/NCUguhKAZHaRLNkoJrT4rJBInAH312uW3x0kvKNPN
 OibU5t1d4pDmm6vTaLNBaXKiq/seHkU6+LGJAtDpP4KLDUW5grMe/BN55NWhhVzfvzWer+fTcoO
 zQrN3VrwUuG66/EsFP0TnQsxka5Q2HypdUsKyd4RueTh3No68i2lMMynyztRIoT02R2T4UrY36M
 B8mmrXpvQSq0sUDJgdg==
X-Proofpoint-ORIG-GUID: LW2VqXTAj6dxTRX9mNwoHZ0F4cqy5X6F
X-Authority-Analysis: v=2.4 cv=cOzQdFeN c=1 sm=1 tr=0 ts=6a203894 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8
 a=O_2PV3spL_lJ-ijEIfUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: zGboYsb4_DxKGs1tOVwSCui615z2o2m4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-03_04,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0
 malwarescore=0 phishscore=0 suspectscore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606030136

On 02/06/26 4:08 pm, Ojaswin Mujoo wrote:
> On Tue, Jun 02, 2026 at 03:44:18PM +0530, Disha Goel wrote:
>> Online defragmentation is not supported on DAX-enabled filesystems
>> because DAX bypasses the page cache required for defrag operations.
>>
>> Add check in _require_defrag() to skip tests when DAX is enabled,
>> avoiding false failures on ext4/301-304, ext4/308 and generic/018.
>>
>> Signed-off-by: Disha Goel <disgoel@linux.ibm.com>
> 
> Looks good Disha, feel free to add:
> 
> Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> 
> One small comment:
>> ---
>>   common/defrag | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/common/defrag b/common/defrag
>> index 055d0d0e..28db2f7a 100644
>> --- a/common/defrag
>> +++ b/common/defrag
>> @@ -6,6 +6,10 @@
>>   
>>   _require_defrag()
>>   {
>> +    # Defragmentation is not supported on DAX-enabled filesystems
> 
> I think this comment is not needed as _notrun explains it already

Thanks, I'll fix this in v2.

> 
>> +    if echo "$MOUNT_OPTIONS" | grep -qw "dax"; then
>> +        _notrun "Defragmentation not supported on DAX-enabled filesystem"
>> +    fi
>>       case "$FSTYP" in
>>       xfs)
>>           # xfs_fsr does preallocates, require "falloc"
>> -- 
>> 2.45.1
>>

-- 
Regards,
Disha

