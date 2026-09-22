Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013020.outbound.protection.outlook.com [40.93.196.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5083A49F129;
	Tue, 22 Sep 2026 17:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790098103; cv=fail; b=H95xmz8hQWSK0bxHuTgMIpzqDXjrnn4yOLthy99kYP5Sr9fP8zICcvs7RaQOjS1QCkT0PUz1onQgC12C5neYoihy8izQdmzeFr91qijcvLb2eeDSIUehOlpe4vZYyAiIVZRI1MG2MzIOKq+ijOdMSEUoxIrM2JUmlyi5JSENz60=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790098103; c=relaxed/simple;
	bh=FE2BTdbSh70Tw574vhMKqa0E49XiVW/+t6TgkG/tZ6I=;
	h=Content-Type:Date:Message-Id:Subject:Cc:To:From:References:
	 In-Reply-To:MIME-Version; b=CUmCPP8g2Ow9RQUB5yF6aEREIoQ7B8Ify9sv3qCtkDFkA37Tjc5O32LiIjhAjoJE6vJ8lO0aZBUTR3ZjkqiTcwYxrLX3cEJLjlrfa4g/arHhjMQy2YR7sgkhTaL4INpS9t2YLUckyHCP37lPTf67MFGurZDrop1GVaB5mgXTy9M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tMFN+kRW; arc=fail smtp.client-ip=40.93.196.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tMFN+kRW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZHsmH9uA2RyOw142fyjgDVi+YPqXgBCMAaKgV0nsAOKq5/PqC60qC+NsGmKrvFLOi70qEIEbI099UhRCrjFSBO0DsKXP/RgzvxOWxVWX8Mr+EEHc07yxeH6cEU4CxGLbwwRdBjoNvcfE7awHQjoQPqUoGN9Ug8MJEzcdJDGbbHfdMaJFGIZnuPFvGsuDiwHUTCv9SZd/WGsNqIIxAlN0xACX126DZG2x2WllTrUj2ATHe7596cWAYkohjuBUvSUs7GaNVg3+j8q/s3VypEvKxJaCx7ohq+z7AKePc1bx957X8dBj0H9OW+9PJ94R1+N0HpCSS0Zc4bw8RmwoRf0i+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cLIBESCgL+1P7ZJfew6WReIZ8MNe7AutBa8ZTYj/pMQ=;
 b=DfO/yPjIzrRsYdn1BXlR8brimV4plDPWf6Pkmxu+E8bckGd57x0r/CP8uwTfbcu1PxutiRLAK5Or5bMoFZe36g+WyoHhObL8trBnDtKNcGAtgTYe/+u2OzArNTp4c1TN9olE/H8iqt8mVTdHgU6i4Fj6KDbcd4aMQt3aZK08rjDNYOHp3ekyuVO9+Sxcm37W6mNeSWhAppCTLo2zeZZHJR6A3n2cim68knnEBbh+jg3wf4TwnduAIrTcSUV33c5V9W67+NogClN4pWLwQzQua/GdoUm0vR1EsJ2Z9kGKis1aBADH4YnysdnTwyLkIniZv5477mvLiRavIZbHj9xWiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cLIBESCgL+1P7ZJfew6WReIZ8MNe7AutBa8ZTYj/pMQ=;
 b=tMFN+kRWuZddgjRxStz/vDmHWH/jMLIYSRHZjkMurk43kxy1+tnbr1opomQi/yHbVkA3Ohf0LRJig5ie4m63mRTlMgprdD/t3PpCAT89ovB+x5lqB1VJnGN8HxejUx09hnPLOnCiGrryGd+3+X48v29WhzI9Q32jElsXbMxlwo2NEnQDORK5eBIOkRo0xxXZB+qilNdUcS1D9LrO6DME1MPAtwx6LW5co5ASxPcMjnsrCgz7WN8rlKCOQu25gm/zzFBKXLboQwaOpghffONkcu1IfcPpKdJe+XKGy81W5enI8Pjl2gGtZxZW19SGrR1hAGjca9d7DWtmyomC2RUKqA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB6415.namprd12.prod.outlook.com (2603:10b6:8:cc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Tue, 22 Sep
 2026 17:28:14 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.014; Tue, 22 Sep 2026
 17:28:14 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 22 Sep 2026 13:28:01 -0400
Message-Id: <DLM0T60C8JRD.11L2TBS45DHBU@nvidia.com>
Subject: Re: [PATCH v4 4/4] mm/truncate: clarify return value of
 truncate_inode_partial_folio()
Cc: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-ext4@vger.kernel.org>, <akpm@linux-foundation.org>,
 <david@kernel.org>, <ljs@kernel.org>, <liam@infradead.org>,
 <vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
 <mhocko@suse.com>, <hughd@google.com>, <baolin.wang@linux.alibaba.com>,
 <willy@infradead.org>, <jack@suse.cz>, <bfoster@redhat.com>,
 <joannelkoong@gmail.com>, <djwong@kernel.org>, <yi.zhang@huawei.com>,
 <yizhang089@gmail.com>, <yangerkun@huawei.com>, <chengzhihao1@huawei.com>,
 <wangkefeng.wang@huawei.com>, <yukuai@fnnas.com>
To: "Zhang Yi" <yi.zhang@huaweicloud.com>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260922110703.468389-1-yi.zhang@huaweicloud.com>
 <20260922110703.468389-5-yi.zhang@huaweicloud.com>
In-Reply-To: <20260922110703.468389-5-yi.zhang@huaweicloud.com>
X-ClientProxiedBy: MN0PR04CA0002.namprd04.prod.outlook.com
 (2603:10b6:208:52d::13) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB6415:EE_
X-MS-Office365-Filtering-Correlation-Id: 267d8f26-4980-4912-a49a-08df18cee1be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|18002099003|22082099003|11063799006|56012099006|4143699003|10067099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	gPuIWsm5XIH1efTr5hTnXO2BD162hqkQx7PBjcu0obHvtUXha/eO1nymDOI2kTxGBloYTzIjU57ghME2dwausoNW/Y3DiiEhmp8Ke3x403Hn7dOF8Csbn1hQyiogEn8d2D+wWssj/cSKk8q+Vw33IXh9Njq9H/68UOV+ezB2M2AP/HWdzqAbh6JAPna06Q+1XuiCCtt8KlxqmIXCICCH0SK18SVD8XbljzPzRZBqowg/btUTmjeben8ZqCH/CiEU+Leb+JzGxwkrHfJiyzdk7mqrWpMEkNbDxE8zwcIMX7YFZ1Eoup5dcgHdltrQ/byWA3nvxCr+xVamTsqGuQy0HKUO0izvAl6tIauOO8opO0GI0/GY2NcMFoLUq5ODFa4hBaZAeioPkIeHhquXyWuAjWj0j0AnFuAXK2YRnSpVFIK4ShgYdD+SmX5nYV9mw6lJahifZb1HDOD/QADto5IcAOWC/ILbyTQ2x4xaVd07aFWHjasIKOKEBCANcyS5nOCuvU3iHE5GciC6d93QhiB0NUkw00j8SsCwtYdk3W+Q2CTZkKcbdIb5NSMHGlvejIVf5qmye4a14fR223z8/rNPa2TF7yhH2+5eYpbMAKPahEK87wuTAdwQFk567opYuAGZIKD0uP679d876FfRRvMNa8eJSInC39jd8TXEoEiJuaQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(18002099003)(22082099003)(11063799006)(56012099006)(4143699003)(10067099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aDZPd080NmRtWGxEVXZnSlJvcVlFeWRKdzB5VEQ4emxIbk1jbUprSmg4Y2Q4?=
 =?utf-8?B?U2tPaUFNT053dGJtQVkzQkE0T0NQUnlhTjJpWHBGZXZFNlZweVJLbTZnd2t4?=
 =?utf-8?B?TnZDOEN0dkQzb2djMlpuZm93K0E2OFVhNjRjTGxvN21kblAweEpudnlsZlEr?=
 =?utf-8?B?enY2WWtkTmZXaUhpenZPRS9DRVBGVEJLVUhQaE5wQXE5d2oxSnJELy9TOFI0?=
 =?utf-8?B?VW42b2YrU21OSUY5cVllOFBxVW14TnBBYWlKV3Jnd2hXZ0pNMzJiNWwxWWlB?=
 =?utf-8?B?MWN4TUgrU2JqWW9zUThpcGhNVE9rT2R6VEdiaDNSTGxzSWJMZmRVMnJIQ2d5?=
 =?utf-8?B?L280dDE0bkREbDUxQzNaa1RQMUVSelp3SUY4Umw2c0gybDJsVzlZUXcxQzRa?=
 =?utf-8?B?V1h5ZlVDekh2akdHVEVWRUFSeSsrSFlLWFIyMGdGd1ZYWnpqYzdsS01qUFM1?=
 =?utf-8?B?ZUhLbnl4ZGNPdm52SlZualRSNk5Icmt0eEQyVDF3ZWtBOFh2MnFlWXcxM2Ro?=
 =?utf-8?B?WXBXV0hPN2NXL3dsSUU1OXRCU0s2anMvdlNnZ2dWSTFDSStsTDlTWDBYVnU3?=
 =?utf-8?B?dHBDd1JicnQxc3RiYWNPSGh6WHJweXVvdWNkOWw1YUFKN2RaMUdOZHk3Q1pt?=
 =?utf-8?B?QUZWVjlJSGpvUHA3RTRDZXNWaTZWS1hlRnFxaUlmMnBES29oai8xUWNYM1J3?=
 =?utf-8?B?Ym9jcllCNHc1YnRXV0lrMzlwRUw3d0l5b2V0WE5aSnpLNUVFaWZ3UFZuYjJa?=
 =?utf-8?B?amNKYzgveVA4QlB1aHVaT1BZTmtFZmFteE1laHc3WmpxNXVtQ1puNTJubE5a?=
 =?utf-8?B?WWlVcWxVLzdrRkNHZjZxQ3czckZHVFUyZStuY1pKNGEwczlHS3ZuNG1wNzN0?=
 =?utf-8?B?NVMzd0VZdHoyNDE3MEpyNkdhekVTLzk0ZnlpSzBjaXBSa2Y3clhBNlJZVUZI?=
 =?utf-8?B?M1JyZjlqK05Kdk94cEc2YXZIQnNJV3JxV0RiSmVHMUQ1cnNxcEVwMnV3MElZ?=
 =?utf-8?B?WEhMWEhZR1pmZTZRZ2ovUmxxM1lyMkJldG1OZzlwUnZmVW91VjEzMHZmNmJK?=
 =?utf-8?B?eEpYREJwYzk1SGtxQXk5WGRIbkttMkZxQk5LdnczOStub0dQN2xvNDJTaVNS?=
 =?utf-8?B?WDNoRkFMUDZhU3ltaEhhTmZLQzZ5dmx5enlBUWMwdUFTQmNabElIcXhETnJF?=
 =?utf-8?B?TFo4WGJNSlI4VXl4WXg1T2JDakNyL3pCM2JLOWY3bUhBYW44RW16dk0zaGd1?=
 =?utf-8?B?UzV3cDRsc1JiNWNDNjVGNFRhaFZrKzZZK045OWlLYnp3MTlCSkljK3lKdEZ6?=
 =?utf-8?B?Qmg1c2F5aHIwUHVTdm1YZjBQcVAyMUpnZldIQVg3YlNsdTBscVRWV2dSRkVj?=
 =?utf-8?B?YzVKOWRXNlpLamJuQkVveGpGdmUyMjJzRnFIOVFsaVZxVDJUZFpwbWh0WGxQ?=
 =?utf-8?B?M0w2d050MUF4MDh5ZldQWEJjazNRSS9jZ09hSEZTeFZqcFhqZkN5RVVzN2Rv?=
 =?utf-8?B?aGg2RlUwMU5ER3MvRUhROXZPZzZWazAyRGEyaExSS3NpQ2tjc2pVTmJSL3pV?=
 =?utf-8?B?Q01BMEc3dFF6d2srdDhOOFRYOEkzeTd4YlNpNWJhOFJPNVpTdTRSck5jWk5Y?=
 =?utf-8?B?aWM3QW1xbjFuYURUSTdZczViNHo3dXpUdzF6b0t5eTRwVUdJeDFQV1p5cXBh?=
 =?utf-8?B?NkZ4K0cxMW1lUE05WWx4VHhjK0J0RkhjZVRpSTQ1ZG5vOTllSVFNaU56aWVr?=
 =?utf-8?B?cENPVFpIREdjLzdaZ0lFUXhYck56VHViM3BaemZGbmNGTWlOWkU2OWs0WUU0?=
 =?utf-8?B?NURWblVNcE1QbnFpdENaSUt0WUk0NDFJcmEvVWh2dkNWSG1HSDJrYWNIL05p?=
 =?utf-8?B?VzhPQ29uYjR3LzlUandVcFhyKytqR3VDbXg4UzhnM21NZWZYYlZhWlJhOUJh?=
 =?utf-8?B?RkkwYzMwS1FMUVVyZ3F3MEIzeTBTS0I0M0ZvT0VKdEo0UlJMUld0bXRXZ1g4?=
 =?utf-8?B?V0lOQ3pRUHN0WWFjUnlJM08xcGx3bUhIZXlWYUZNVTdRWHJZSTRYeGRscU1p?=
 =?utf-8?B?UjlROVJzcnREbHpnblhoajdiUjEwcTZOTk4wL3RnWk5BLzlFdTFobEFhY0Zz?=
 =?utf-8?B?bnl2dnpNQXZZVmdNcCtRMTg3WUk3Nm9oTFYycFZVdlltOENZKzY2b1lTVWM2?=
 =?utf-8?B?aHkvalV3WjdHNkxySHJPN0xzRUxRbVpHYkdwSHpSNGN6NHNzTENkMEdkNDhX?=
 =?utf-8?B?MXdwbGxZWXc1QUdyMmNkeW9OVkhtQ3NlMGlnd200UW40YXlkWnVlemlBK2xt?=
 =?utf-8?Q?cG+K9fCRN88poN25+F?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 267d8f26-4980-4912-a49a-08df18cee1be
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 17:28:14.0624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jgUVXlT7U0ghXb+2FxKCFdZ6FpkxnI1UAJ/URKJfhIdfwe0WK6KAvMqL+bs6EaqJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6415

On Tue Sep 22, 2026 at 7:07 AM EDT, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
>
> With the earlier rework the callers no longer rely on the return value
> of truncate_inode_partial_folio() to decide whether to adjust the
> truncation range. The pstart/pend out-parameters carry that information
> instead. The callers now only use the return value as a flag indicating
> whether the loop should be reset to pick up newly split sub-folios on
> the shmem path.
>
> Return true if at least one split succeeded, and false otherwise.
> This clarifies the existing confusing return value semantics.
>
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
>  mm/truncate.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
>

Thanks.

Acked-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi

