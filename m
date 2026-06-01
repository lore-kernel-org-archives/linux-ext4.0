Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012020.outbound.protection.outlook.com [40.107.75.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9A43491D0;
	Mon,  1 Jun 2026 07:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780297216; cv=fail; b=d18o3U4+D9zwNKxxGe9nxIObgwIf7vgVqecmn12jsOFx9+cnF53WvsQkt6JLhvUpwWySmsN3GeTnQ0mNxYJ/S8KgDgzkWs4XpNNylR6nSUgei2kOdqYEqPqm2EwVuGQwkfsFUqL8ibyxFsX9xxfp5XWnep600i80CbhCoSnCddA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780297216; c=relaxed/simple;
	bh=D2D4LQxcNQaEITbQ7jcqvG31+JSyTsNYdIqyNsywxSg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NJ+NDsByGGi6elzUH//McQEROJlR0Yyy7BmKF8CvDpx0wqqzUFpxsAlYwqfjoATEwrn5ZS/Jw41LyJ7yy1jwTQqvJHcwXsoFF1sKSMu6hP6RJqyGRuEsiP/aSqd11fczuRPGVRWeUNHsPtNXDsJSDpeQVLq1Me/mzfA3gw7/6Po=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=SqknXjmK; arc=fail smtp.client-ip=40.107.75.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="SqknXjmK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NzQ4bUGbHXCe+y1p6d+0lmPyxFzlGdQw9cRQUPhyHdihZrdr03tM7ZSxYHh+izr9r7EjfZfq7GSBT/JscRzaKQGZEciEoxRn5YElIU13vjywFnC+oYdxFzc6wj+BjeY0OwwbK/db9cmdAeqCJJaaMu/LQKomrZNQU5hz/GZ6Wat7q1xA9agN3GEI/M3XkoRQ0N69y+2Ta11Cq7mFRmzUyOIjkByj8FTa4e4S8RltMC/yLxVSNOzWG1+HbbrdSaYZmJYjy5lZFGm9vJUZ7THfhUsxlzGymAgPzxgsNm8ZB3EQjmCDZ2DrWBBi2WtMWlIj6N/KrnVxsN9s8/mAwKgf8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EKA6xhCkGGc92tOH2XryW8AJYkHuuUNhD/GTs/44a7c=;
 b=pKg1MLT6gcrvc1F4Q7InLm1NaULAEOIpIUSAsDFocmqths3tpHlp9Zll/Sg7rrSF4piM3kBPYV5w0BjR7/y4SNGBOVoV+I7eD9bvLfK+g45bl+P+A81K6widRGK4AzMnz586u1o0BYGJN4/5Ro+1T40E8+lp280pvkQARzfCsb0/XJVesGDelLoL+c+LkxOXPATUChIK3JwGSKetri8/tnWsiz0KEw3/+aUxI4hph1JxmFqsF511hRk/FgfZI3+rXA0y/ZwS8twCFJ08ZZ2vXNX2r5JehlsA9Ax3TkMoFpa/pvFgH2MwhbQczLqagOlQLYBYkCF16nowpOIDrbrzCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EKA6xhCkGGc92tOH2XryW8AJYkHuuUNhD/GTs/44a7c=;
 b=SqknXjmK+SCI/F1Q8jWN8oWv6ujpaf+LQKy+PlIk8Qs++uPnLrArSP3ch9WRycEMQp5AA2+fTVp7bVWn0pbAgNrLZ0GlHqopS/8fNkcPS2b2EVlLjAYyDp5dUGTZxUoJq9wQbM/j10tDRVpGi8iHajqZ8/FfBD8WH7YjG39r66fS2TAesQcBlU67ILaNDXIAFVTA2435mMaITWfuOAZA1oHLBSCYxRTqwBUYVulDP3i1EETZqn8uZGmwQKkiwtP5o6KiM4nzpdf+Y2FM9VtzEdXVXldm/pL6h3biiSn6/dV3RZWB8zkV7TTIk8k09fKifPmByKGMgCK7ga+DvBsQGw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYSPR06MB6921.apcprd06.prod.outlook.com (2603:1096:400:468::6)
 by KUXPR06MB8655.apcprd06.prod.outlook.com (2603:1096:d10:a0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.16; Mon, 1 Jun 2026
 07:00:11 +0000
Received: from TYSPR06MB6921.apcprd06.prod.outlook.com
 ([fe80::ee5b:12c7:2366:cd1e]) by TYSPR06MB6921.apcprd06.prod.outlook.com
 ([fe80::ee5b:12c7:2366:cd1e%6]) with mapi id 15.21.0071.015; Mon, 1 Jun 2026
 07:00:10 +0000
Message-ID: <be69ac6f-7a4d-4fa9-a686-f6988a985a38@vivo.com>
Date: Mon, 1 Jun 2026 15:00:05 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] pipe: mark blocking pipe read and FIFO open sleeps as
 freezable
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
 brauner@kernel.org, tytso@mit.edu, jack@suse.com,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260527064912.1038-1-daijunbing@vivo.com>
 <20260527064912.1038-4-daijunbing@vivo.com>
 <j44pojzowtbta2pxeb6nfwnw3mu4thlx5o73es3a5kivibwnvs@cqhwry46h2fy>
From: daijunbing <daijunbing@vivo.com>
In-Reply-To: <j44pojzowtbta2pxeb6nfwnw3mu4thlx5o73es3a5kivibwnvs@cqhwry46h2fy>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TP0P295CA0008.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:2::20) To TYSPR06MB6921.apcprd06.prod.outlook.com
 (2603:1096:400:468::6)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYSPR06MB6921:EE_|KUXPR06MB8655:EE_
X-MS-Office365-Filtering-Correlation-Id: 783c67a8-8e21-4242-a715-08debfab6ba0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|22082099003|18002099003|5023799004|3023799007|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	sm3qjzx+XoQ5BUgFuTjeA0wcMx/e+SA0aRTPVZz4uPmUYe5qvGc5vEUKHXK3BDicjzX+GbbZCrZ8YQj1yy8N6bzIZa2CRjWrm9MB9xpJdtI6cd7eXEdtPcm6uJstrhGPurp7jrs2nvjYoN1wZ68GgTulmhRbXw5XyIVnXO/t5K0eitvXYQst2rI2jm5hKGJmjapXMQI3f6UCHJ3OTZCHt4pzgfT1RpfgSStlyxF8Z+sT0Yj4f6BTTyd5MiC+pZMAKgOWMVca/SySiGoE6sQK4+L5uBivWt+VlwHZn2kcgJkvdHqrVioNtDs3ZCTxHp8SQuDqfl/hdwkRdHOn1HX0ONVbi8sClcZ67RvCsGtY0Xakf5F5ENvQknn5ViGOU/v0pODy3EA/gHnFyJ0Nmeh+gubMxO2r8KzdcYVY8BP+7j5GdF/OL/oVnpyv/7wxM8XHgGRwNE+VWlQ4rlXZZs+gXbDgT7Yuuj9UB9jlD0NljIxj6Pn+4LNECrrjQlc4m8B+IJEyHCgRAblSIq2gju9i9uMQnGcxYLljqZxnSydx+PoTpQrB3SYYeKetns5KU0oyIKvKrkH6aJCf2d6RCyFT1N+lFE48eoh2YoW1sskWwDusU0m2NpQgSLXdb7oVqcMK90jE52pXOjHapWRl5GsLNyUjK4U1YmQEFI4M9zjHUD3KbtCN9O3A3hZrUg767IBH
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYSPR06MB6921.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(22082099003)(18002099003)(5023799004)(3023799007)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dHdYaFVWTVpWYlkySmFiVTV0Sm9QdDMxTmdVOVM2SGFjdlhER3VCL3hPS0p3?=
 =?utf-8?B?MytkRXhtYmRCUHdrRHNZMXhZdW1GSS95WHFHcTBhMDQ4blVWeW5SRHR1MEd5?=
 =?utf-8?B?SEdPS3dYTjFUZmc1WlJqeFAyelFNb1QxVmpHYmw4L0lubCt1TElNNXdVT0dJ?=
 =?utf-8?B?WUhLYit0VWVHMzNLL0h0akhQaHFVT0JMcHovMHlPOS9DRUxyM2IzQzhWbTJI?=
 =?utf-8?B?R3BuUm11cWJ1eFk1anVPc2RxQ1l6T1BqSHFmUEFHTis5a3VuVjhwQjM1Z3lU?=
 =?utf-8?B?cHZQRXdwSktmS21CTmlna2dGTlplV0dUeVozQ1BUZGl2U0FhMFdHOXZRU1kv?=
 =?utf-8?B?RjhvU3ZYdGN2R3U3Z2FoU1dQMzdjSjFiSGZEQzg5MmxpQm5yM29CV3kyMTFn?=
 =?utf-8?B?c2Yza1dkYmVYaVd2SHNWWXIxdW44cE10MmtxTEQ5TW5tZDBLTjM3WDJlUTFz?=
 =?utf-8?B?bDA4bU01TFE2dW9obk53VE9YWmxwcnZYTGRhcUJlYTUrWUd2VEVldUhBNURI?=
 =?utf-8?B?YjBBTXhrYkZGNjdudkU3ZHk2amRPU0VDODhXTjd5a2dHdjJGS2pmUzU1R0p1?=
 =?utf-8?B?aU9FR1ZTeDRKS0FPNThxTG0xbi9Fd3hjc093dGZjc1ZZTnB3eFJjN2QvY2w3?=
 =?utf-8?B?SHBkbWVIRnB3cDRGakpnS2RUQUJxSERpQVZWd0F6V2RBc0dKeTZnY25QNDNa?=
 =?utf-8?B?R003QXk2dWhTL0dTcERkQlJHSUptcUo5ejhnNE9FZ3N1blc1aGtmNmc0ekhj?=
 =?utf-8?B?WUpJa0VucW5rQU9QK3BCZ0h4ZERaOWdVMXlnZjIyOGorb3hLdVJBNTZjd2M2?=
 =?utf-8?B?MXYrSWttY05wbjRpS3Q1YmJKOXpQbEVCMDFORmtEMWlldjVBLy9GMnc0aHl1?=
 =?utf-8?B?d1Fid0x3TGVYTHk5TkZyRHJzUG5vKzhmLzNJQ2hhcjd3ZDZPTDZ2b3crRWJo?=
 =?utf-8?B?YTExdHRCT1FBQ1NOVzFXTzdxTzhTalZ4L0FSNzNNQ0FVQjk2UVBKU3cxN3BN?=
 =?utf-8?B?TDR5elU1ajI1SUJOVWNpSW95ZS9ZRDFSbkhqeGNsekd4WDF4WFF2RjhnRUlz?=
 =?utf-8?B?bkh4bUJhckNCNFNiOWVBVWtIaFd6ekF5cVppdk82ODRoOXVvMElhM3V6cjRS?=
 =?utf-8?B?T1ROaVNyRmlNTXptUXlyY1hJQkY3SXpSQjZnWWt4SmM2L0lSdi80UU0waU1V?=
 =?utf-8?B?c3R4S2lFbG9leStqajN4QVZwN1NYRHk2UnFLN2xFeFdwVmtrNTZtL0R2eGR6?=
 =?utf-8?B?VjJLdlBQWnllRTJ4eHpPdFpPc3NQQzcyTHR2bVFMeVRaRWViblBNeHZwZTdI?=
 =?utf-8?B?VHNrbTJqQSt6dGlIWEo3WUFTcS9McTJOQ3UyakVmQVZ6WC9SU1hkUlk1bmsx?=
 =?utf-8?B?ZTVXd1E2MXFEK01PNVNBc2k2MkRtYVJMZGZzN0N6LzVCTC9wK1pnNnFEMjNP?=
 =?utf-8?B?Y1Vva0lwS2VSNk1RZ3d3Tis0ZjllS21LNWc2Y3RnTUNUTmdidUMrTG9CaHB3?=
 =?utf-8?B?Rk1yQXFOWUpZWjJLbUV1MjVVUkJEbFpaMVByWGk5amtwdmxtNElSd1hiUTNP?=
 =?utf-8?B?UkVPcWsreHlrdU52RXJQTHB5QVZ1K1ZNdXJOMU1tRHQwa3JlTGNRdHdVZWli?=
 =?utf-8?B?RWloeUdoaVhJQS91dVUvWXM0NC8zS0FWMUdxVjhCY09LWi9KT0FUZ29Na3lp?=
 =?utf-8?B?S0JONE5wWmNXZk4wVEMzbThVMkFOODFjMDY0cThQWlpRSDVWSTNUWUlablhm?=
 =?utf-8?B?bHl5R0VYVng0VFpIaUV3Uk8vREhVSWFid3BnaXJ4WktRYzZCL0NYT0QvbU9P?=
 =?utf-8?B?SmwvRjg1c1NCdjYydTUxZkRZZzNPbmJ2NXhhK0ROZFNydTYwdjB2cUlyWkZK?=
 =?utf-8?B?dXExMXl0aHdTVHNZZGRxbWVmWks4cWVlVlRrVGIvOUp0K1lkRzdSVGpCNkxY?=
 =?utf-8?B?UFZEZmFkaVN6QlFNUXBGdDV2cUpWdGJRNWlYRk1rbzA0ZzdKWWE1TEtWRXpn?=
 =?utf-8?B?aTZJdVptWDYyaHRQK2JUcjNTRC85dDJ2a3R6V1l3cThtUGY3aTc1Vmo2UU5W?=
 =?utf-8?B?L3h6bVlkTHExZGo1S1ZQUFVRUGxvVWJucllsem4xaUhzak9LQ3JXYlNyRVpu?=
 =?utf-8?B?aEI3bDJ5TWhQZlI3bkdiM21aNWF5bGU5WTNOQU9HMEYwWlZlbnVsRjJCK0xq?=
 =?utf-8?B?blk3S2NoTFhwZ0RDSmtuRzFWMW1EK1g5YTk2VVFYRktQbjlVWHNORVNSczda?=
 =?utf-8?B?M1N5YUM0dWNIR21yNEh2V1ozejdIbkY1ZXdBNC8rQk9sU2E2NGhzWko1dVk4?=
 =?utf-8?B?a1UxNnpicFZoK08vVnF6SExiM3Y3WXRmNWRLN2lYUTRRbDdNRTdldz09?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 783c67a8-8e21-4242-a715-08debfab6ba0
X-MS-Exchange-CrossTenant-AuthSource: TYSPR06MB6921.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2026 07:00:10.3135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3kUnOwV/XIhwTREn0Od2RCJQRFPxEcxAxxqDpEvLERTTuI4acU/jM/lLMrXjayyXpbrZJxe2lHQiUZjt/1kHdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KUXPR06MB8655

Hi,

Please drop this patch from vfs-7.2.misc.

After further review, I believe this change is not sufficiently justified.
In particular, I do not have a solid enough analysis to show that making
the anon_pipe_read() wait freezable is safe with respect to freeze-time
lock/resource constraints across all relevant call paths.

While this change has been running on our devices for about a year without
any reported issues, I am not confident that this is sufficient to 
justify it for upstream use in the general case.

This concern only affects this patch; the rest of the series should be
unaffected.

Thanks,


在 2026/5/30 18:10, Jan Kara 写道:
> Making sure we don't hold any lock is rather non-trivial in some cases. For
> example in your case here, anon_pipe_read() is used in .read_iter method so
> you should make sure all places calling .read_iter don't hold some lock. If
> nothing else, I'm missing this analysis in the changelog and I actually
> strongly suspect it is not true in some cor

