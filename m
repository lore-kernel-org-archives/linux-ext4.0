Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6603D332B;
	Fri,  3 Jul 2026 13:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.166.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783085055; cv=fail; b=P/5qaSDAcg1S0Hsbvy9uYIbSbSGMF9nAdqpvXScYfwEPwrw9zHVK8538vocwKShDNj6mRNmI3y8Kal48D+YzZqnyans9MsatMmg1fiFu+yUdplOH/df2Zpy5pM4x9l0FBa7s5pornBtjDGbc2Z/JUWjGfTbjWSqEzop9yULuI+I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783085055; c=relaxed/simple;
	bh=1Bv5fVVpwC98SG2tX0jn/2NsF+zDYOIz+VwWwdwu1f0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RL7aY0k13g8mz3CTCcV7X2q72g+eV6ywYcFJcUIS0ooJgLssu5A0Fv8UZO6tKUamkpNYLizhx8weST7RD7JoEdoIzfsk7Xdnv0ALSFAVXdChXivxALlYeY63oJGYnRVnawcU+aJzY3yNlRgrvxjVqQHkRhJHWvxbVFWLlkZO15g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=ZkrHfziD; arc=fail smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="ZkrHfziD"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 663AH6Lc4111846;
	Fri, 3 Jul 2026 06:23:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=/ieDpqqld+bUQq8m0qgnDUzc/IguuX2Qn7uuV4EWXAo=; b=
	ZkrHfziDc6IVtpX8Z3NSRiRuAiI2Bn8XBohvSXz/4m5K5AjlC8JRDIX1thvsZD2j
	EJbNnQmBCmlRvoYcHpc5rVCxujLe8yNy/0XkBzRi2y9hOHIwcDTAyG2RlZiic7yA
	yJ2yieh/NbLseO5b988l/jHrPqr00qFq+8xIqnAuLuGCv1CXtOkMZk9qDycKeDcX
	8RdH4W57Rg5F2Uv2aHHXmDi584LSSR5/8ZVzrtI/ZhLP+5FQojHoCQ4tCDMuNjO4
	w4tuaAxX0UebRSDdkM/8LGZwm5cgWHJG2JVOKjYpLTBGj7qZe1MOF0Efg1Le4heY
	1YlMDJ0t0e7Jo1cssxo8lg==
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012056.outbound.protection.outlook.com [52.101.53.56])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4f69aprd58-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 03 Jul 2026 06:23:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F8otW+QSHvv50Ns8MJ5pGnWeVAvsPPfAlcq4NVZ7YtK1OjlEiyuXGsQc4Uft275PzhvY7TEYlJj6JhXqqmHU2xYESu+fG3ZCJtpTbSkxH43uPPXD5+9Qjdv/KrNbEy+5N/a85CsyIDq4RypqrDryhPqxAHrvILvVzRpU/UhSxSB4zHa6giKP/fc1js321rq0F/osTj8+fEzmOB7Nb72e91gpBBhTJjDhvsun2L+VuRa0aZWm0swQK60fshSLgt4wN6x0WflfnAbvUVf1TJrUudPF6J8FuFXqhnaCYwUXypQuH4z3Gdjsix8ZxcjLqE+z6T4XdaFbNkjZuA2Zccvtyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/ieDpqqld+bUQq8m0qgnDUzc/IguuX2Qn7uuV4EWXAo=;
 b=ppAovEL51BT2R7kgrwo95A+PToACeU83uVP40CV7Ijw1LfL6d5ky0GjI0loNW9md3SKQ7UOMvZBJL2A5LQHT63H/8QyghmrQ1jUYffRUyh712fYeWEbdw3gvXYSZeWGoIv+K9ptVB6i7h0elJwzXGkw+R6Cr80QV9Y854Ii807qP5VB2yk3kcl/ccp+/l7nxacUr3DBJ2kBYHIQHIZjTxJGx9BGDBhRGz3rVn3AWkb/g+vNUh/BmC20h46p7oB/5Ga7mXGSlgfI2ROl0X9F1SLAz+D1ptw6qNdarzdbdASO6FCDmlUtazkxRvqv1C570F3Xx/gAJpfondvolcZQCuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by CY5PR11MB6139.namprd11.prod.outlook.com (2603:10b6:930:29::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 13:23:35 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0181.010; Fri, 3 Jul 2026
 13:23:35 +0000
Message-ID: <949e6295-a75d-4164-acfc-3cfb2570228a@windriver.com>
Date: Fri, 3 Jul 2026 21:23:25 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ext4: fix race in ext4_convert_inline_data() leading
 to BUG_ON in writepages
To: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com,
        jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
        yi.zhang@huawei.com
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260703032304.4088040-1-yun.zhou@windriver.com>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <20260703032304.4088040-1-yun.zhou@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TY6PR01CA0026.jpnprd01.prod.outlook.com
 (2603:1096:405:3bb::19) To BL1PR11MB5333.namprd11.prod.outlook.com
 (2603:10b6:208:309::23)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|CY5PR11MB6139:EE_
X-MS-Office365-Filtering-Correlation-Id: 834a1fe9-b006-407d-5d68-08ded90648ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|18002099003|22082099003|56012099006|5023799004|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	CBONGMMXwemYxAVUWMdlEmJLTbDwDbF+8p7FOLQuXdjZH5viNano22iEBfPIMjkhFxnccrbwubqIv7b7epWxnUqRQJBLXHZs+ob8cIQdE3INDGVbYLrS2G/HzhiWj2opEM0ywzXLWY1UJchtulrUEO9Gj/0pnRHNEk9Sn4tL097lQMHG3U/WgEEEJ6clD+fgtYJcJIkn4H6d1gapHItzrZ1Biv89zS2oloaFVtMCIIlrLx3rUjld80olhtzXoBa181hxvLxRk5rhjcFduapHedN7EOkT010DtwECvUj/gPk+8kZQyhaM6dxJRijftUREHVn48uNTiIAGAqTbB0FXRHihw0GNhe3WIy+J25uY/Ub13fMwLlMT1LCmqiwkk/o1z0RMQuVTou4MZbtxEzC7UlDYetppAzKiG4rgbLfeajNGloqnMopck3N9XRHJEPjpuj6ii/BC1+nHv3OYRBq5k+rnq0Uabb0fUMdlpU/5q6njiZhc+lAz7K5x5mI7gm80FQlF3LU8w2DHABrlFjimOs3H7kjrXGHboSlpGdJ9oCYEPYaBSFcVQ/p6/nOq/Hj+EgsIdV0FnIvET88XgVul++kQWrHRLJM9HrCnkPGqqbn+ccDf6h0QTDzBei7rrqOS
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(18002099003)(22082099003)(56012099006)(5023799004)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dThIZm1Cd2I4M2c1NDlienBlcnlxUVlndGd6ajljaHhnbXN5K2p4UjJBWTNz?=
 =?utf-8?B?WWlZOTBSTHp4RlFUTld0WkNJUVZLdFY2OWMxdXNQTjV1b2RTdE5WNWdHeDJK?=
 =?utf-8?B?QUsvTnBUTUdqSEZYdVQwVzd3bDhESUIzckFnamg4UnZ0Q0FRMDA3YlkrSitV?=
 =?utf-8?B?K1dCRmhPeWlncW9iS2wzTmM1dVh0dEtRblVBNkE1TEhKTjdFVjBuNnB2R2hN?=
 =?utf-8?B?Y0pVNlpmdyt0ZDkyV2FpbEZCVWN5clRoMEhTUGNocmdPTzMwd1pBZUpKeW56?=
 =?utf-8?B?akJ1dEcreTN5cndkVzBJdkdWeUcwUWxKTDhtVGlzMXo2ZGwxNHFqdXVUb2Uv?=
 =?utf-8?B?dTR6OGtNSmMxemVDRi9tMlEyVE15a3Axc081QVJZZGp2eitSQ0RGT21Hazhy?=
 =?utf-8?B?MlM4UUhIejFxQXVtYkZLNUZXeWNueW9NQ1FZTXp2Qjh3bmd6RjUwSlhLU09j?=
 =?utf-8?B?RzZlR2c3Q204YTNEWkNscGM0cWxqNFFMT3FrQ3hzMWFzczZTV2xzcUJKNElT?=
 =?utf-8?B?a1lWVDhwdi91aE1ldFJYRWpoc3ltNjl5MkM0czNrdWF0MWRWRmtXQjBQaDRK?=
 =?utf-8?B?dTQrR3ZEbit3YW9XdDJHR2ViYUIrM3NoZjVTN1NhMkE4dDRya2Q5RHRJaDFZ?=
 =?utf-8?B?UnhhRnpCM2N4a2ZhWGsyclRDV3kyeVpUbFFwUUxpS2ZYZ2VIM0NxVkNzY1FI?=
 =?utf-8?B?NHppWXlvOEFNdjFWSzRWNmplZW1DMHJPUDVIVlRwb0NQcTUzM3N4VW9mTHNn?=
 =?utf-8?B?dGxNbHJtbnkzcWdGK2ZuM3pVRFV3b0VWMnFOU2J1UzJYNnZidDlUMzNVRm40?=
 =?utf-8?B?R1E3d1hBQld2TksxL2xscnhtNUdEVUVoa1l1RUQ5MkQ4UDNEazh0NElleE1V?=
 =?utf-8?B?VzFuMEw1WExoZDY0Yk1ScVRhb25sckZYMTR1OG9EMGQ4cmNTZkJNa2gvdG1Z?=
 =?utf-8?B?ZjdraEZIVi9QdzBPUXdORUhFVjVuR1AvL05qSTk1emVsMHVtYkdWdGRsN0F3?=
 =?utf-8?B?Q2p3UHNwT0dJV3NKcC9HaHJpWVBsNXF3dEFiL0c4UHhZcE9NcjBIVlpXZkR2?=
 =?utf-8?B?dTdPSFUzQjRNK05wRzhvb3ZnY29keUE0WC9SaWs2WkJzTG5nK1RIdnREaGNY?=
 =?utf-8?B?c3FrQXlQUk54YVRNbXFQK3FGSnV1OStBSXd5TXlZOHZwc0JSMTNadFJmUzVQ?=
 =?utf-8?B?UlhDZEkwMXFhQ2creXp6LzA4ZTdiY3BNQy9UakdOZVRkWWdqVFJSa1pwQkdT?=
 =?utf-8?B?RnorZng0NklBSDNDbWtTUitacGpyUEJOQ0FVWmF4TmhUU1lmdk1kb0FtNmlI?=
 =?utf-8?B?VHNhLy8velV5MXBFV1hkWUtGS293MUo0NVh1QVdIVUxKMGNzeU43SnN6TjN3?=
 =?utf-8?B?d010U1FkYlRjM25saG9mYi90RUptZFUvS0gza1JtakZnVk1NdzhjVDAyR3Fh?=
 =?utf-8?B?aVFCczBRUVNzQnUzZ0hQRzNUdjhueWhCWkV5b291ekU4ZUU5eTVBam92S1lL?=
 =?utf-8?B?Z0JBYlJyWDkwTVk3ajRRMTBhaDFJWDJzU3FiT0s2ZWg1OWV2YSt4aTF1NXNX?=
 =?utf-8?B?amc1Q2ovWnducTNSdEZEcC9PNjBFZHlUajVGdTZHZklsMmtMWGtSSThYYjBB?=
 =?utf-8?B?L3VDMVBpZjI1NFpLWGhRRFZOZWJ4NGFJTlhxN3JIY2dheUlhQUhKK3JYYWF1?=
 =?utf-8?B?ZklJWGxyek5xYXVFQTBWeXg1WVVwbUVXdFZTY09Yc0pyRk1wOFVTbERGYlIr?=
 =?utf-8?B?ZlpqTktwSFJnZDJVUXJoNGV1OXVJUnVEbmp2TzVycjBHWmQyYnI2VGEzZzlZ?=
 =?utf-8?B?SmY0QllCY2J4LzdUSU9GYloyanhBNGl3U2oxUy9HR04yczExTkZTcmJ4UEho?=
 =?utf-8?B?ZjBFZlRBVlp1UG1FMUYzZjNmZ29jajJkNXZLTWx3dWwrdXZ2V3FROFdxMXQ0?=
 =?utf-8?B?d2tZZjMxNzV5S1VrRVNCN29DWkgvanFFbWlzNXZzSERTZ1lPSWNqS2V3QWlI?=
 =?utf-8?B?anF0bU1rNllSTEtRdjNUQXBNR2oyOGlXbHFteEE5THdxNU5yYmxaRS9wZ1dI?=
 =?utf-8?B?ZEhKSUkxQks2d2N0NUd0T2w1c0UrdW0vYTVGNCtNOGZKalF2SGRVYVZRaGRw?=
 =?utf-8?B?QjREL3NxRUNRMHVaZC93RWw4bDdpMWhUU1RyUlB6bWpvNFFaa280SjhtRWZp?=
 =?utf-8?B?M0JTaUxHM05NdTZGdTQvVUZYVDl6MjhrTlc2WEVPY3BtS3lqRmdVd2lhL0xX?=
 =?utf-8?B?bjRVcm1xY2tDc2RmUGFXanFJOWhQME90SXk5TzYrdGlxdmJFazkvMVJTNkdT?=
 =?utf-8?B?OGtjbWpvZnRoY01RTDdOZUNpeDl6RWg2NGpkQmJRR0JDMEYwSFdydz09?=
X-Exchange-RoutingPolicyChecked:
	Uwu4m36HWuJYGmn+rTjgkmAliNtFDBdY68MfktYMPmQwLGBLMSRCpxqwVwzUBXekJzftJREovHT1+QoLbTnYZGJn7OsdWbh2we1RShi75oQXd2lGXHdhKMyY5ujo05Y+iXmZW+fjQ9G4Sk/vN9wPCGVo6U6GY0twgQaZ+qVEXCx2H6ceZkprdFP/bbOTUkp0MMnlZKRYWkI331c2BA4mu4lZQ5UAL2OqopNDc8MMxjGbDS3mF3p27RHqVBW7GwZ5A3+cYQF6fNUpfY3EitZ09xZLsUKTN4jdJ6GpOynJ8o22Fd24HXUop4m8nvgqqjScQPgSkscbhxA9rHwvo8pytA==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 834a1fe9-b006-407d-5d68-08ded90648ba
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5333.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 13:23:35.4296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DUWrTpUeJTllFgxojvpeeac/v0zYCnIM07TIuShPeuYxRashADAsYM5YJpg8or83A+m3X6QqNHB4b27GG0vtmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6139
X-Proofpoint-GUID: P7WvSpszK-YJXuQHJKtVG1wgFM1-m730
X-Authority-Analysis: v=2.4 cv=LsiiDHdc c=1 sm=1 tr=0 ts=6a47b7db cx=c_pps
 a=68eZn42HhoOzQwLNwT8gAw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=iKiJcTA2PjBS6x5JeXcw:22
 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8 a=yPGdDRAWh3uypZTnXdcA:9
 a=QEXdDO2ut3YA:10 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-ORIG-GUID: P7WvSpszK-YJXuQHJKtVG1wgFM1-m730
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEzMSBTYWx0ZWRfX/aRj4hrPBRFM
 1icVqzJMhplLbf8+JxvMLWMRIgyprsPGIm43SVIOmfHxtu0Ta3L1Cy/yYATpRcmrgvKfA1uREt9
 sT5amA0xNg9X+B8ao0qLOOJfqO3Ki2e5Ug7LZZBP/N+9hnJzYcyd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEzMSBTYWx0ZWRfX/VKRevY6CJCY
 sTPc5UodgYcMbttBdL2UWOHjVIPmu+BSSAky68O3HTqTbl00YeHPZ3ybZF+1x7gDVkazf6Tox79
 Ga9XJQR8FGAWmD4k2V99Uis3cRHB0xfKXcJZoKRBUIKI4U3ofZPKcdrq+QGtnZf9uIe9obaolAh
 6bsd+z2HopZ1OGr6OMAKhhPQEXGmIi6N03ow1Mj0ezsAzkRhFW2e0glfELtIqN1vKLpfw3tcFYA
 HBSAbY1kWqZKiIAnlJHxw9an4WoUS7rQEHZyUx4hbm/32jzmXKaPQkG7ClIHpT93y+pnuSmofuF
 hgTAg4YnPryOaCfjjUv2iy2McUnVD06ZhaBXi0B1hBl3dyEGTiHYBcwDi4+2BNCrCSlDco5heBs
 yuAZ2wshXGHq2m5HzELt3Z2O/uPNKcGYxK6rrc0ovM/Y2iiVCNnFD8YIp5SR6gWIG+O9uVbQtZx
 7fY7VtY9jsWxnZstGCg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0
 clxscore=1015 lowpriorityscore=0 phishscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607030131

Please ignore this patch. I have fixed the issue flagged by Sashiko AI, 
and the updated version will be sent out shortly.

On 7/3/2026 11:23 AM, Yun Zhou wrote:
> ext4_convert_inline_data() has two unsafe lockless fast paths that can
> observe a transient state from a concurrent convert_inline_data_nolock()
> that has destroyed inline data but then fails and restores it.  A racing
> thread sees the transient state, concludes no conversion is needed, and
> creates dirty pages via block_page_mkwrite().  The restoring thread then
> re-sets inline data + MAY_INLINE_DATA, leaving dirty pages coexisting
> with inline data, triggering BUG_ON in ext4_do_writepages().
> 
> A similar race exists with ext4_da_convert_inline_data_to_extent():
> after it copies data to page cache and clears MAY_INLINE_DATA, a
> concurrent convert_inline_data_nolock() can restore MAY_INLINE_DATA.
> 
> Simply moving the MAY_INLINE_DATA check inside xattr_sem would require
> taking the write lock, starting a journal handle, and reading the inode
> location on every call -- even for inodes that have long since been
> converted.  This causes measurable performance regression on filesystems
> with the inline_data feature enabled.
> 
> Fix this by introducing EXT4_STATE_INLINE_CONVERTED, a monotonic
> (set once, never cleared) per-inode state bit indicating that inline
> data has been successfully copied out to page cache or a data block.
> This provides:
> 
> 1. A safe lockless fast path in ext4_convert_inline_data(): once the
>     bit is set, return 0 immediately without any locking overhead.
> 
> 2. A WARN_ON_ONCE guard in convert_inline_data_nolock(): if the bit
>     is unexpectedly set at restore time, warn.  This should not happen
>     given the MAY_INLINE_DATA check prevents entering nolock when DA
>     conversion is in progress.
> 
> 3. Inside xattr_sem, only call convert_inline_data_nolock() when both
>     has_inline_data AND MAY_INLINE_DATA are set.  When has_inline_data
>     is set but MAY_INLINE_DATA is clear, DA conversion is in progress;
>     skip convert_nolock to avoid destroy+restore re-setting MAY.
> 
> The bit is set in all successful conversion paths:
> - ext4_convert_inline_data_nolock() on success
> - ext4_convert_inline_data() when inline data is gone after nolock
> - ext4_da_convert_inline_data_to_extent() after page cache copy
> - ext4_convert_inline_data_to_extent() after block_commit_write
> 
> Fixes: 7b4cc9787fe3 ("ext4: evict inline data when writing to memory map")
> Reported-by: syzbot+d1da16f03614058fdc48@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=d1da16f03614058fdc48
> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
> ---
> v3:
> - Introduce EXT4_STATE_INLINE_CONVERTED monotonic bit for safe lockless
>    fast path, avoiding performance regression from always taking xattr_sem.
> - Add WARN_ON_ONCE at restore point as sanity check.
> - Skip convert_nolock when MAY_INLINE_DATA is clear (DA convert in
>    progress) to prevent destroy+restore re-setting MAY.
> 
> v2:
> - Reworked fix: root cause confirmed via ftrace.
> - Removed both unsafe lockless fast paths, serialize under xattr_sem.
> - Skip convert_nolock when MAY_INLINE_DATA is clear (DA convert in
>    progress) to prevent destroy+restore from re-setting MAY.
> 
>   fs/ext4/ext4.h   |  1 +
>   fs/ext4/inline.c | 44 ++++++++++++++++++++++++++------------------
>   2 files changed, 27 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index b9b0ada7774b..310aeb14f9f0 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2049,6 +2049,7 @@ enum {
>   	EXT4_STATE_FC_FLUSHING_DATA,	/* Fast commit flushing data */
>   	EXT4_STATE_ORPHAN_FILE,		/* Inode orphaned in orphan file */
>   	EXT4_STATE_FC_REQUEUE,		/* Inode modified during fast commit */
> +	EXT4_STATE_INLINE_CONVERTED,	/* inline data copied out, do not restore */
>   };
>   
>   #define EXT4_INODE_BIT_FNS(name, field, offset)				\
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index 8045e4ff270c..1b6abacf12e6 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -671,6 +671,8 @@ static int ext4_convert_inline_data_to_extent(struct address_space *mapping,
>   
>   	if (folio)
>   		block_commit_write(folio, from, to);
> +	if (folio && !ret)
> +		ext4_set_inode_state(inode, EXT4_STATE_INLINE_CONVERTED);
>   out:
>   	if (folio) {
>   		folio_unlock(folio);
> @@ -921,6 +923,7 @@ static int ext4_da_convert_inline_data_to_extent(struct address_space *mapping,
>   	clear_buffer_new(folio_buffers(folio));
>   	folio_mark_dirty(folio);
>   	folio_mark_uptodate(folio);
> +	ext4_set_inode_state(inode, EXT4_STATE_INLINE_CONVERTED);
>   	ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
>   	*fsdata = (void *)CONVERT_INLINE_DATA;
>   
> @@ -1172,8 +1175,14 @@ static int ext4_convert_inline_data_nolock(handle_t *handle,
>   	}
>   
>   out_restore:
> -	if (error)
> -		ext4_restore_inline_data(handle, inode, iloc, buf, inline_size);
> +	if (error) {
> +		WARN_ON_ONCE(ext4_test_inode_state(inode,
> +					EXT4_STATE_INLINE_CONVERTED));
> +		ext4_restore_inline_data(handle, inode, iloc, buf,
> +					 inline_size);
> +	} else {
> +		ext4_set_inode_state(inode, EXT4_STATE_INLINE_CONVERTED);
> +	}
>   
>   out:
>   	brelse(data_bh);
> @@ -1959,22 +1968,16 @@ int ext4_convert_inline_data(struct inode *inode)
>   	handle_t *handle;
>   	struct ext4_iloc iloc;
>   
> -	if (!ext4_has_inline_data(inode)) {
> -		ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
> +	if (!ext4_has_feature_inline_data(inode->i_sb))
> +		return 0;
> +
> +	/*
> +	 * Once inline data has been successfully copied out (to page
> +	 * cache or a data block), this bit is set and never cleared.
> +	 * It is safe to check without locks -- the bit is monotonic.
> +	 */
> +	if (ext4_test_inode_state(inode, EXT4_STATE_INLINE_CONVERTED))
>   		return 0;
> -	} else if (!ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
> -		/*
> -		 * Inode has inline data but EXT4_STATE_MAY_INLINE_DATA is
> -		 * cleared. This means we are in the middle of moving of
> -		 * inline data to delay allocated block. Just force writeout
> -		 * here to finish conversion.
> -		 */
> -		error = filemap_flush(inode->i_mapping);
> -		if (error)
> -			return error;
> -		if (!ext4_has_inline_data(inode))
> -			return 0;
> -	}
>   
>   	needed_blocks = ext4_chunk_trans_extent(inode, 1);
>   
> @@ -1990,8 +1993,13 @@ int ext4_convert_inline_data(struct inode *inode)
>   	}
>   
>   	ext4_write_lock_xattr(inode, &no_expand);
> -	if (ext4_has_inline_data(inode))
> +	if (ext4_has_inline_data(inode) &&
> +	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
>   		error = ext4_convert_inline_data_nolock(handle, inode, &iloc);
> +	if (!ext4_has_inline_data(inode)) {
> +		ext4_set_inode_state(inode, EXT4_STATE_INLINE_CONVERTED);
> +		ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
> +	}
>   	ext4_write_unlock_xattr(inode, &no_expand);
>   	ext4_journal_stop(handle);
>   out_free:

