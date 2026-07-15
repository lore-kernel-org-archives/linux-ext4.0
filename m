Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11021087.outbound.protection.outlook.com [52.101.52.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99DC28725B;
	Wed, 15 Jul 2026 16:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784133056; cv=fail; b=XLuEdkHjxn64SvgR9ilI5gdLLthfHOfmJWwF0KB3wgBMGwtvBzD0bmGHleHbNppiyn5uMBLU2Ya7RnljyFaWmua5MjHODLCx1pXA3SPGVkiz/JACH5U6F2Uf/RoM69FFq1gDdJGU9syTCeJuDa2TKn+TFyyPgvigGluNpRyEAbg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784133056; c=relaxed/simple;
	bh=wXfP/9xdDR54ON4HssAYAsYiu7zPlpaH7jF8i/bOv68=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YSwXjXlU06nASisT59EUZxQo3jiGeqZN+grRiTsOsj/Q3ixaJt5QoEdanbDnkjhTMXFhtGKjrqh7bk9CE7m0jCmrUjntFDIv2WY/sg5MhROR9kSZvCQ3RaLtYjt/iac/tPt44mYLbAOjlBx3r2d7u9dusptQ0JrHNPieQtki9aM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com; spf=pass smtp.mailfrom=thelustrecollective.com; dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b=3hM8ATG6; arc=fail smtp.client-ip=52.101.52.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b="3hM8ATG6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YArnoN2l/WxnJTvJWdveEat80A1xVRHTgD6orNZAASKgYO7oaIzUW1Mo8athXwZq2KJOZ65fFiEDQkhFdR81SVwmw0qY+kZcs24U4VsasDuNmZ3xz6g4H6FxJvdY6c1gLDoC1fvZbV6Oi/gXCwfJfwYQ0TQWZlfnkMAFuFv6f0vfwuBrvvSzUJaUXCpi5dDzGI2Tp16v5rwJkToTCnD4aqkU20hgYvN/s9aYwxYrsCEkIIuZH9Q9rtxbZH0q0ddhHzXJJ7S2KY3LQpfNn88iu6BVECUyV+MWtltdhP7NwhP1E2IP0vMYx/qq62B8VhENtME/p/VVhtc4L87N67Gk4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wXfP/9xdDR54ON4HssAYAsYiu7zPlpaH7jF8i/bOv68=;
 b=qip15NkzXxHWTwmCMw/SfHY7BgZhcl2XUfkwSI7HGgv+Rqad36WLb5CMzf21/rjmjPyUCMMdWES4WoYDU8CCoeJROsQhNf1OVvvmShqgXh9TCiWY0BGgv/IVf/PofTUPugJ5wxHBRyJk+mCLXnv2RRal2z/jtXideM6lrN7XzAnaoPsN1I0ORrCviLEd//RTcamfpqaoZFF/QBSuxpptcbeZRtfzGSfMpCUwYCDqQO0YuJIVClFqmzkXSrQ0POWGHTqyxqa4FObO9LMmUjXRLjN0zqlOY5zC1VLvLnJkWy9wA4R34J/uS89pbWVN76mJRIxA3ZgTnMhoXJdjsh1ehQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=thelustrecollective.com; dmarc=pass action=none
 header.from=thelustrecollective.com; dkim=pass
 header.d=thelustrecollective.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=thelustrecollective.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wXfP/9xdDR54ON4HssAYAsYiu7zPlpaH7jF8i/bOv68=;
 b=3hM8ATG6nXRLiGO9uQpXKl+Vqq4Vjjomhf1izRlxKD2SWR6hFAIBpHeA0MrqT4rSMPt2O2bHeaLnRMzL8gxVDy5rhusUVRFN2qLo4AP5fJMv+zVARQws/AdNZrs9EwV94DpG8IgixtRlDnmcIqwmRRD6kx9U1UdY3JPlXhk8kd1Ghkn9kUmYuFdpk532TKol3FV+Fyhmg02sIL0/wmCpw4S1HwcjmrgiMi3Q+E5JxxWkKK2/Mb+D1hP/fSXeTkZYv+9AkUftFKMZOwe/IOaSuyUcDqONOTfYzpnezjaVfgjW7fOnkKK7gMSL8SiRDzmZ5BKcWw3jH7ohMnZ/mtZhtg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=thelustrecollective.com;
Received: from DM6PR04MB4682.namprd04.prod.outlook.com (2603:10b6:5:24::20) by
 CH3PR04MB8814.namprd04.prod.outlook.com (2603:10b6:610:17d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.19; Wed, 15 Jul
 2026 16:30:46 +0000
Received: from DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee]) by DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee%3]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 16:30:46 +0000
From: Timothy Day <timday@thelustrecollective.com>
To: Marco Elver <elver@google.com>
Cc: Timothy Day <timday@thelustrecollective.com>,
	Theodore Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.com>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/9] ext2: fix ext2_xattr_delete_inode() context analysis warning
Date: Wed, 15 Jul 2026 12:27:42 -0400
Message-Id: <20260715162742.280285-1-timday@thelustrecollective.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <CANpmjNMgH3sX-RoOjo4Vo2Dqx7=3rov1Mz02u+vKt4WkNuSg3g@mail.gmail.com>
References: <20260712165610.366474-1-timday@thelustrecollective.com> <20260712165610.366474-2-timday@thelustrecollective.com> <alT2yHlfzhTZ9n4T@mit.edu> <20260713164417.350710-1-timday@thelustrecollective.com> <CANpmjNMfQT6Z9ke4x49sp6z8+pt_5ZLUoSh0da-99bwos5-8Lw@mail.gmail.com> <CANpmjNM5CmQc_YG_5=zhdLCr7gGL3QYPcd4R4=m2NzwNY03d3Q@mail.gmail.com> <20260714211246.1046948-1-timday@thelustrecollective.com> <CANpmjNNU_GiRW6y24hvbUsXze+jf+9ptx8_Acq1Y=mvPSr=wFg@mail.gmail.com> <CANpmjNMgH3sX-RoOjo4Vo2Dqx7=3rov1Mz02u+vKt4WkNuSg3g@mail.gmail.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: IA4P221CA0005.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:559::10) To DM6PR04MB4682.namprd04.prod.outlook.com
 (2603:10b6:5:24::20)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR04MB4682:EE_|CH3PR04MB8814:EE_
X-MS-Office365-Filtering-Correlation-Id: d0ea87e4-0d26-468d-2a08-08dee28e6be4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|18002099003|4143699003|56012099006|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	0gXOZsKtuEpnhSE8fRQaZCulB6h7EwaAmn3GIRcUwv97kexotvB7ZVpVFUKRG2S69XjBQMgRDAUOyg7SB9k/7u03T9Ilu0yMtKzWjaf+lNdKhdlQ5U7iagc8FbwNaxAMosfM81NuaaYvTAzkn4O88dJmky4MTnw1lSOkPwwA6cwUZ1eOX7zfEzSDqpr4ev/Oh6ic2uRSWQI17D3MkS0WJDF4GQ59jEtInRjBB0fJjSnfihxN4YQ+LU8OwHnv/Ge++ahQMLybT3WznTg+o4eA14c5+qGL7mNizGpZHRm8R5KjNy5tF8XwDPvAresAnGu/3wAN82xXo99n06/YhvO5aRaKjrKm56XterQ4snyji7lmnpYpjRfWl5rr09RmBIMdGBqk10TbW8rewdwKu26T9p1SjaOKvdR8q2wtZZ7+JqrwkJ6MM5Oo4Qr0irMgc0VYt13cIQehhGZFRvB17b9ZxICim5+QkCTVZayKBAbQUFXBB3eGpTf+qRbvC9j6kHrFCz52UZX2GQ9t6TKs1tsed7zefoAySgOtyjYYH0ap2Wgoz7TcDoDQ0d0WxGP/cMpzm9sn2VmuFTP4mXsE38gx2x0yqHScQyTxlgY9++7nuuqeOrzoMY3+EQptRnVqW6UP2ehLRVoxqtg2tirKW1IfB9/xOrZul0C9gSk4c+SMcEM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB4682.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(18002099003)(4143699003)(56012099006)(22082099003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IXeNOToUPkzaklnEJVm12ip7nADD/01/HXMBX8d529hiyAsk6M7KmnY1P4Wt?=
 =?us-ascii?Q?e4tHMIz3QMyj6Jh8bmteysJZnU8JgL96W0aarCL/Xfbf8LQ/+ZNaXnazuHZP?=
 =?us-ascii?Q?W0cu4yghZMy3h20S4kj9CMfd5iojYnLh7ek4A5iL485YAzi/gKjqP66Bk72D?=
 =?us-ascii?Q?F2Ty6yIjJmGsYQjIdzMsTUSrPQnw9Sc61m38UA/QKOmHQ0efERAqsEUJIVXE?=
 =?us-ascii?Q?EYY6OGymLfoK50kwS3Lwz1VGPcu44TG3o6KKZnqR85yAxMJHBF/tWebZxJlO?=
 =?us-ascii?Q?kiiF66BDiu954KAG5VPU/fXkVneJc1AiC/6URv6e52xPkix4xAamcw2FaCmx?=
 =?us-ascii?Q?WmlsNAWNacljwc2rqyL1NSFPV/U3Z1A4sz/NEssC7XqlcbrHvFpstAAX466i?=
 =?us-ascii?Q?cRUifOUejhpD+6fwbOVmih8KDSOZCKIYmKQH/X9q2jIDXla6hq7ZGdhNj7it?=
 =?us-ascii?Q?0M4JF01myez/EM/GC0eyBDJ0IDjhCz0eU3ulQcpxdiKmXxDXYmOuBgrmwd2t?=
 =?us-ascii?Q?hWhE1ogZISpqhAdjaj9C/RkNPfQigCy/i36vmaVB2006THpRsv60vBLTy95x?=
 =?us-ascii?Q?BX4mjro3+0G0PI4hMCv/K/TttiDaxU0x/mpFpDb2JWVh3uZEon7ahkFUaCkM?=
 =?us-ascii?Q?CwEmzs2wR/6zLvlHxZnlOsqYUSKASqEtBQI1SRZsjI6lO35mlV9kXRNkgJev?=
 =?us-ascii?Q?pAbHlfnj1Q5kM9WQ46DTVovHYzDZDN0zRpBmOAGiv88esRlgTa6YHei3zZhN?=
 =?us-ascii?Q?Uoyb1DBY6424rR1GXctBfH06ME3XRxYekySya77KPRdnNM9KFAfre7sBYEce?=
 =?us-ascii?Q?uI7DZVtWUHfM9iIsOeIy4kRabwStpidv7fLQT5QkSOg/X6LC2CeoQXxLc/i1?=
 =?us-ascii?Q?SeyPgOOib4ZJFaa1d/xhdRu72ZPYO/Eo76awS6i8L+W9fv2TZbum/xgBJse+?=
 =?us-ascii?Q?iGpkM8nMQpS9hYH87YoeyMumk47BLB9yQGenR/e9mS/PHJR6lLrtZuBGzqeQ?=
 =?us-ascii?Q?Elf/SZsgPAKI7UtFtTPKcEyrv/sU66xSSZmJfpoR/KXv6TuqZsTshlGQP1o1?=
 =?us-ascii?Q?ZcUJst8LbmOItPN6FK2yhsp0cPffyZmBnfehXNWvr9r2lrWF3b2JgWvUcM2W?=
 =?us-ascii?Q?P7V0zJOmSYlzrovjEqs8r1a3lhoVylYZHlyEtVE2x2IIlI8WkKjmhUw8rj9A?=
 =?us-ascii?Q?IaSf5toGTtJA+7nkV1lQyA9XdpuCvKRcAMmDryBB0LDUff+7yZTEoHZ3gjwU?=
 =?us-ascii?Q?/w4I7Z18kct4LhWeB4GWGt7vHQ2btldXJgN3Z4GnjazM/7ABEOvWNsWhmtIA?=
 =?us-ascii?Q?7UoMxfIzMXy/vsS9zQTlUt49rzE12VqWM6gwYCUiMAXuSgPHs+v60RglPVyV?=
 =?us-ascii?Q?FPqtSP6g7Wn2NTJqi4vQobKwgXAgO+O6uWJkCrE47qjskyP4bYdJS4ysqktA?=
 =?us-ascii?Q?iqcNeplRYjTqF8Dl1yLB0lsN6585TcSXWbqiV3SbMG7lt3r9Rp/5SpksL6wS?=
 =?us-ascii?Q?b+PkT0wbjZUWs0hZDcC+FOYdxoBbye/aiLL83pQI6fu18s+0lfL4uawy59d7?=
 =?us-ascii?Q?zRudmTSCgp6/qTkjdpdwfoBAcKnP6wiXLjg4MUk+/pgc80dgCIa3YeY7Cw22?=
 =?us-ascii?Q?d6yQD9I4Guvfr6x1fUx+NXcr507oj/WrrikvrlGc6IIh76dd2t6SNJKuPVDJ?=
 =?us-ascii?Q?uG0pQAtqMfEB6MG7KnU0uEi6woj78dT+KLuFmaz4J3+3bDFLBRiAt14v4+ar?=
 =?us-ascii?Q?oUHYVDH2DeVM0RtArlg7Dwpe2IPhq5I=3D?=
X-OriginatorOrg: thelustrecollective.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0ea87e4-0d26-468d-2a08-08dee28e6be4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4682.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 16:30:46.8577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4c9dec06-8f2c-4233-98d5-ca3cb36218fc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tzl1xsqxw5FW1+8eF9pREtYswRCQvb+4TUmijftopU8TcVm8qnFdOC8o4z4a7N852KlahtxR+jHpHHCAAvZKxK3DpfZiz5NNkKCBVd7hLGc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR04MB8814

On Wed, 15 Jul 2026 00:52:07 +0200, Marco Elver wrote:
> My Clang PR was merged. Can you rebase and send your Clang fix and add
> me as a reviewer? Please add a more elaborate commit description,
> because it's a little more intrusive and the problem and your solution
> is less obvious.

I submitted https://github.com/llvm/llvm-project/pull/209796. I tagged
you in a comment, since I can't add you as a reviewer myself.

While I work on getting the LLVM change landed, I might try adding some
annotations to other drivers. I have a series for infiniband/hw/efa/.
And I've been working on Lustre as well, since I want it to enforce
context analysis on it once it's accepted upstream.

Is there a roadmap for future Clang static checks? Other ideas for
using context analysis? I'm really interested in using Clang to
improve the correctness of kernel code and I'd like to help get this
adopted more widely.

Tim Day
