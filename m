Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010014.outbound.protection.outlook.com [52.101.61.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBD63D75DE;
	Thu, 20 Aug 2026 16:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787242378; cv=fail; b=GtbH1apW0zsi9GlH41jBH4S86/SBMxlzVcv7J6XO5F13ZdQzNp6Ybi7dMM7/IGHYJemwGWctyD8CXDWZn8FL4+tUYjzVd8FBDbr+xCURGNAYTrCGGdbZ2ps7F737dQwUQY3wjrUfWB4zCOOeQUWIBIi4x981xwqfz2Go8wYRAiQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787242378; c=relaxed/simple;
	bh=GQwNxZNRb7QfVL5uH97DO+3qCLdKNGVBBEl7WltKtn8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EqslJ6hOiO7p67sTjSus20JBlCy3VBYW9qzunPgwzYvSoSCgiavD+ODrhk0Ws92JQvVPPeWUbaPNmTFhcRyiUKVxqgpmvJEtKWF7Yyjo+dfWKMGNOMsBvPV9Z9PQwC39ACIe0nwyP2skVfwQlzfzyThX/nYuN/7U873opCStiLY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=m+vO74j6; arc=fail smtp.client-ip=52.101.61.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="m+vO74j6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f3Uc5FdNgXa/DWjk8UUj7JgJQBpAvUIhou3ndjHFD6ixU1lLrWEAFXE5BcI4LDZ+6tWa95B1/6tLHftEl1NzXSk9cjNJCGlJF4pY794+/SX8bpY07HoRMRyRIQxQFOEyVxMf4unobpLhOAsQ41JXw03eP8ULqwxEKkMSE9BwFaLA76zZeh4LLmlMfUOZHDCxtiTOu0r3/I7mTRjlBXPLifBjQ2vjIuXUTETq/nhyFCcKpO3LGEcp94DuWKyaWeBxbFfGG/+soKyxKhhwAL9CdFaZrZQdDjY6flcdE4u/xx7Nbqs1UcTthKY6LeCLiiREMS4nEBfim/LzkBpHKLYDtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dXQACOlMqYttdwf87+MdT+hgACB1lVKrO6r8CW4/KWU=;
 b=oi4foruBDTxzCm5vPGH2kNphFqYT/GM0953Ftl5dLyNgyB8lwXy3fTTb6rAmvKAPUG7ye8KQuQYENzFHWjRHLabgvpZz2P6nywUG6zsVJTCHNYGkbDD+0KCyjpysZbaqwhuSkP5PiFSIFzRSy7eIOaYnMSqlX37WH0DXeJhsjcHDmoWr9l63Du+gZKywMt4CWYn+6VgOTRY6NER7dD8XUzbQML8e16SdaCQYS/YKE6d4VkiykrNiMXs8e6PrUmzn6mBMaO3uF++vxqwNHs5rRVZ+xWkqYXWSNI8tcZ7GwdZ+5X5hE80IfXz2JsFNgoCXBBOwyRZfSt23WCfQN0RAng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dXQACOlMqYttdwf87+MdT+hgACB1lVKrO6r8CW4/KWU=;
 b=m+vO74j6BdUSjBj9JJqSTFitMc3/WKuIUYplZHoaHToDpuLZAFuspnhpDliJtg+krMFHpARp5V+JADFacIFFcMWnB4s39hT8QJ5NYiqptIukyWWdJ+YXBWuQijL9ZOQRbhJG0Xja/L9Jno5AavzKs2ylZqUpnSEc2RzZEGSPsThuf41eorCZugY0lTo0U0/56Ak5LwK86IcBxon3Uu7Hdq+bfDIK0a/PbkLc9lMgmV5nh+aK8lUUex0am0ui9fniHxo2ePBZQZjwbV4m/pmCKTA/y90pmuFnCKIrbGznsLrA997W1MfkaHpdsKHVTTRo0lZ/YUUCwuHNFyv5v4rcrQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6051.namprd12.prod.outlook.com (2603:10b6:a03:48a::18)
 by DS7PR12MB5936.namprd12.prod.outlook.com (2603:10b6:8:7f::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.10; Thu, 20 Aug 2026 16:12:45 +0000
Received: from SJ1PR12MB6051.namprd12.prod.outlook.com
 ([fe80::96e1:b300:7b78:d3a9]) by SJ1PR12MB6051.namprd12.prod.outlook.com
 ([fe80::96e1:b300:7b78:d3a9%6]) with mapi id 15.21.0339.007; Thu, 20 Aug 2026
 16:12:45 +0000
Message-ID: <c8a8ed26-973a-4fb3-a72a-f595cccaf1bb@nvidia.com>
Date: Thu, 20 Aug 2026 17:12:30 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [patch 06/38] calibrate: Rework delay timer calibration
To: Thomas Gleixner <tglx@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, x86@kernel.org,
 Lu Baolu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev,
 Michael Grzeschik <m.grzeschik@pengutronix.de>, netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 linux-crypto@vger.kernel.org, Vlastimil Babka <vbabka@kernel.org>,
 linux-mm@kvack.org, David Woodhouse <dwmw2@infradead.org>,
 Bernie Thompson <bernie@plugable.com>, linux-fbdev@vger.kernel.org,
 Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Thomas Sailer <t.sailer@alumni.ethz.ch>, linux-hams@vger.kernel.org,
 "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 linux-alpha@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev,
 Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@lists.linux-m68k.org,
 Dinh Nguyen <dinguyen@kernel.org>, Jonas Bonn <jonas@southpole.se>,
 linux-openrisc@vger.kernel.org, Helge Deller <deller@gmx.de>,
 linux-parisc@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
 linuxppc-dev@lists.ozlabs.org, Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org, Heiko Carstens <hca@linux.ibm.com>,
 linux-s390@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 sparclinux@vger.kernel.org,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20260410120044.031381086@kernel.org>
 <20260410120317.978403520@kernel.org>
Content-Language: en-US
From: Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20260410120317.978403520@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0205.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ad::19) To SJ1PR12MB6051.namprd12.prod.outlook.com
 (2603:10b6:a03:48a::18)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6051:EE_|DS7PR12MB5936:EE_
X-MS-Office365-Filtering-Correlation-Id: 403b744e-fd37-478d-d403-08defed5dea4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|10067099003|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Hku/AQpoDLljpIsWMTOh6NT0b3M4gjVgbDMQtZDjU7lXVe14SpA6/bMJ/hEkj9LRXMDZc7FgK5B7dIFn/CHKklGKQjQcJ5HpNDzmN4TKY20Ud1Ntw/F/UJRIbfErCGYCpzKCbnsGv5Rsmspv/qDZZMPDLYteMPrfcm9qcqIou386zjVU0KOD6ACvP7kcbIDxFnr2GqtbdqL8bY8sUXWqGUlv4c6fhxY2xVpptb0nBK3djNHVjf/NAv2yl+67I7weZjtdPKG04+hEBivIYgrgCFoogdONpMrqUAfSOafaB3UDz20/5WomVhqmSpYtrB1RHBs95+qY0mcngiyx02QJ89MoeuMuCg8spER2kwX5y8JR5TLeEBUjo/dxShi7fZFNO8nZluTUWeJ5s+dPpfjqhCBfsgwXWTYeRxsOmvw7HoZh1XUWJawnikpP1z7aso0Uw4+C+NnaK7ooXLl41q4ivktSsWadUaPhPbbaflbgUFM6l7fVWJ0oNy0Ml4vnpgTHsf3EhEUAF4byfE3GlG8sVSkbqqV6/ALcKCAsibKQVvo8XE5OQzN+lSLP6tVIEqcx90W3eZbmKOd+fvU/1uqsXkhdsQ9hHhmqrP9vzYi/pz9OQgvoKKo7+mZyPERQMtInUTYJd1znCNef1XIVfITbXvd8OCnivO5+I4a/LRJsI7s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6051.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(10067099003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d2pNYVJsZ09NOVNLY0hqVlNKYTB6cmFCSHZ1dUdIcHRKVS9ldzlPZ1c1TjFk?=
 =?utf-8?B?b3RHYzZKSDk3Tm45d3Z3UGl6RENmYVpOcDhibUorY0dDa2s3NG4rRWZ1S0du?=
 =?utf-8?B?Mk4wNVBGb1Z5ajRsZFQyZmJGSGFCZnVhaUplOGwvNWxFVUVkdTNDNSt4Y0Vz?=
 =?utf-8?B?SE0zWGptVlBBTUlRdUIvTWdHeVVNelpmVjlKWHA1ZG0xdEpaOVd6dWdoTWEw?=
 =?utf-8?B?b0tOR0NFVlVoNllLMitzLzNhSk1UU2NoNWJ3NFhKSklRMXBKYlhqY2pDdE45?=
 =?utf-8?B?QzlJTnBXRzZQdFZIV3hKaENqTEs4Nkx1UzB5NmlBZUJUekY5dDAxQ0lJVllH?=
 =?utf-8?B?K1VaajRPUHlwUm0zbUdLSnVhU0RJUFJSL2JwdW9XNTBYVzJYRGNsNG8vSHgy?=
 =?utf-8?B?STc2TnE1TzBWRmIxMEpHNW1PbVZtWUxnQ0owa0FsbUhORnBlNjh6L1J5MnJF?=
 =?utf-8?B?OTBtOGsvMitsSVFoVHU2b1R3TEpBNW1TUXdGZXdqcmc0TzBobkJ0UFpibU1F?=
 =?utf-8?B?WUdFaFpzV1lvRVg4ZmRZRXRWdEY0bXV6c1Y0c1MyWktqSWNUVHNtditXaFdN?=
 =?utf-8?B?b0UvUEUzTUlndEhPSDhjSXVydkN4MktGcGZaUHlwbHRvQ3AwbWt0ZCtvQ3JT?=
 =?utf-8?B?b0R0WkYzT1ROZ1FBYU1rRkhpejJlcjRBekRRejBkK29pRUd2UXlqb2oybndV?=
 =?utf-8?B?WWV4Q1U3KzFobitJaW0vMHBDdk9hV3JHUVVBdWRzS3lURXFNNzdHN1B4eEYy?=
 =?utf-8?B?c3k0M1RNK0VUK1lLYi80YUhsQmhTMzVWeHkyZTQ4QVh5U1ZhRmJVcFZUa3ky?=
 =?utf-8?B?aDRmeHlSckRnUHFOZmZFRkJoNDl6eThaTkM3Ry83S1hnckhycU9JSzBQL2Mw?=
 =?utf-8?B?VjZvYW5ndGEya0Q0THhlQlZwNkNmOWdtZDEyVUoybDc5SSt4b0VPcnV3Ri93?=
 =?utf-8?B?bkc5Si82UW5vaWp6NDk1cy9KenQ4QWliRkQ3SHJRNkhVc1g4MmMyZjJXRHVz?=
 =?utf-8?B?RFJ4QXI0Vmx0SkRQTnVWZk5TelgxQmF4dHdMaFlvKzQvdXo2Nm5IcjNvby9O?=
 =?utf-8?B?NThMVVlIMHptZE9jK3dIeVhrLzJ4VFhWS0Y0cGpaZlMzb0JQT2JrdzN3eVI3?=
 =?utf-8?B?dDRnaW9ZNDFwVWlmKzYwL1hLekpYNEZET0RETGRDMlVqQ2ZlVXBTd2NOQWlx?=
 =?utf-8?B?MDdiZytFeSthWjh2V0FQSzV1aWUzNUtURDNyZTVKVWlUSkxjNTFiYWkxc05T?=
 =?utf-8?B?bUk3cnBjZXkzSEdPTDRCY0JkOXoyTGtxeXR5Mm9UOEFFMzhUSkg2QXBKSW84?=
 =?utf-8?B?aHdvR3pHcDNsRXppdEo4YU5tWDc3ZGxPY2tpeVhPS0ttNS9aeDkyUWppR0dG?=
 =?utf-8?B?VkxwWExqUlRRNWNMZ21IdXBCR3BSY0cxTjM0Z1J1eHoxcGdINFRvS1BhWjRx?=
 =?utf-8?B?aXJIK2pRUHJFNU1LUUpiTldwYWdFd2dDK1R5Z296R2w5N09IdTJNZXQ4N05t?=
 =?utf-8?B?SHJDS0JEMVZKMjdmNDY2Vzh0emtGRExTNVJkQlB2OEJoR3FXMVBGa0w3WE9C?=
 =?utf-8?B?cHdLYnZIbFFSc1JqVE1vNHkyakVMV3VMajVqaEcvSkdtYjdhUWErVlBoMW9W?=
 =?utf-8?B?TGNpR1YxSkdUc0s5bTFUejlESmVleXVwSnhNM0RLZEhueUFQckhLUW9oejJU?=
 =?utf-8?B?bUljV3M3eVJ0eVpjN3ZKWE9hWkduVk5FMndZU3BLdHRldUdPcHZtSmtRd296?=
 =?utf-8?B?KzloVzROdDQ3V08rR0pnU0kzTVFVcmJBeFRtM0pSL0dxcldkWmhvRUFHYThy?=
 =?utf-8?B?Um9DTlF6dE1JenhNUDZZcHRBelB1K1VrNHdTYXpwS3N1OXZVRnU1bHRGb1ZV?=
 =?utf-8?B?TW0venp3eHM2R2xpMDVadFRNOU43ZWhTbEIxVlFkV2pxNGQwdXd5MlJjcXVE?=
 =?utf-8?B?N3BHQUMzVHo4cUJGSnFBUzkrYWIzTEI5b1prUmtUZTJ5d0tjRmRwRS9oREhN?=
 =?utf-8?B?NkVlOWJoNjJUdTNOWmNNYXRzelZDc0s1cTVvalVQaW5pVEpCMm9tYjI2eDh5?=
 =?utf-8?B?SDl2Nzdibk9sNVR0LzVNUXFZSENKa0J0Q0l0Ym1UQXhWd2RYdFE3NU5aS0Ew?=
 =?utf-8?B?Ri9Ha0dvb0x4RlNBSExObEEwQjl5MXNKVEJpdGZtSkxGR2NzbFpqNGlWVlNZ?=
 =?utf-8?B?bitWS1NzRVFlbW51YUVRS0RWWDc1aTdleTdZQWxub2tIVDJ4b0w2eGJ3OXc3?=
 =?utf-8?B?R1ZCZmJrbWlYOGF5aUFvTVN5VDJ3SVRXQXRNQVFFVXFvTFNSOG5IdGRlZDE5?=
 =?utf-8?B?Z0xUOGxEOGRkVVJMVHgzUUNoTHJOQ0YySDNWbVJhcE5RNDVBWHBkUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 403b744e-fd37-478d-d403-08defed5dea4
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6051.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2026 16:12:45.1194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ye8rvQlQdxke1Cm1o4X47OnoHKOhjeOLZqyz+t1/mQTrGPAo/TLtIte6ObxvJ5yITO80ujas5jc+bmfZJt3IoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5936

Hi Thomas,

On 10/04/2026 13:18, Thomas Gleixner wrote:
> The header define in asm/timex,h and the naming of the function to read the
> delay timer are confusing at best.
> 
> Convert it to a config switch selected by the archictures, which provide
> the functionality, and rename the function to delay_read_timer(), which
> makes the purpose clear. Move the declaration to linux/delay.h where it
> belongs.
> 
> Remove the resulting empty asm/timex.h files as well.
> 
> No functional change.
> 
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> Cc: Arnd Bergmann <arnd@arndb.de>

...

> --- a/arch/arm/include/asm/timex.h
> +++ b/arch/arm/include/asm/timex.h
> @@ -10,7 +10,10 @@
>   #define _ASMARM_TIMEX_H
>   
>   typedef unsigned long cycles_t;
> -#define get_cycles()	({ cycles_t c; read_current_timer(&c) ? 0 : c; })
> +// Temporary workaround
> +bool delay_read_timer(unsigned long *t);
> +
> +#define get_cycles()	({ cycles_t c; delay_read_timer(&c) ? 0 : c; })
>   #define random_get_entropy() (((unsigned long)get_cycles()) ?: random_get_entropy_fallback())


I have noticed a boot regression on some of our 32-bit Tegra platforms. 
Bisect is pointing to this commit. Making the following change does fix 
it, as delay_read_timer() now returns a valid value when true ...

diff --git a/arch/arm/include/asm/timex.h b/arch/arm/include/asm/timex.h
index 94e40c19cfc5..4d31eab9dba2 100644
--- a/arch/arm/include/asm/timex.h
+++ b/arch/arm/include/asm/timex.h
@@ -13,7 +13,7 @@ typedef unsigned long cycles_t;
  // Temporary workaround until timex.h is cleaned up
  bool delay_read_timer(unsigned long *t);

-#define get_cycles()   ({ cycles_t c; delay_read_timer(&c) ? 0 : c; })
+#define get_cycles()   ({ cycles_t c; delay_read_timer(&c) ? c : 0; })
  #define random_get_entropy() (((unsigned long)get_cycles()) ?: 
random_get_entropy_fallback())

Cheers
Jon

-- 
nvpublic

