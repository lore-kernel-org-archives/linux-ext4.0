Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11023099.outbound.protection.outlook.com [40.93.201.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7601F5EA;
	Tue, 14 Jul 2026 04:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.99
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784002659; cv=fail; b=BPaU9IjwblFU+y1iItL2tuaswgN42/9o+mlOsa6nelxRdzN/Z9M/QDOV8nlo/+YmeWIzfbeCoQalREBvrr/VBVo132Fjjhq8Qq0f7HTSCzDVQzlD8+qeqyxmmb3ccP6lvsMu473XRp+3jH8VPqlaBCzenYpedbFjrrPFTffAtrI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784002659; c=relaxed/simple;
	bh=KhJRnXHcdUXNBnhpaXJ6GtGMcM9zHo/xCFzmlqVzTts=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lHC/VrucJTEjsljn1oxSz2Q+Ke5dFor0yeOKVgYWPrq3Ps1uK63SUSaAYWOiWfQqJPvu8B5xQ/JefekP6DvqjSBgJaar8isgbBqyroPNrJL46L4SF7G11Wx60/zma6pImLFXln7APd53rqqEbyGOQQmbWpJMUtmfwpsSDcosF2g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com; spf=pass smtp.mailfrom=thelustrecollective.com; dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b=pICX6pi5; arc=fail smtp.client-ip=40.93.201.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b="pICX6pi5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hcidwdjOd+qkNhHtp1Prwz7tzFYgsxQ+hvclue3j6Lc6LqIjWR0QDJ0n674xzQgTp6lKM0ww/Se+gi+nHtH3tVVM0xfHasDM59gBV7JZr3QxEAIjRmqBNTyTNgIgZEyIWicSZipPbL4L5czUbP1bSFVUpmOpGkkxhCZ74I5CaxsO5mHihG/0MGQNNwpRNo9MONjZrFTr8NpYrTtxwgaX+zXbJL1Gl2JBNl/PGpzItxk72bnTwvKusitJ2wVahHsqCqMmlp06MG/RTWVg0t2f/hM7T2GtzXB7vQzJ2tGrIcyxzWkBGSB/N1k8jtnlkTRjp+UVCTkQ4zpSq3CzAo6IHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uonq5BUAXpqBtrlun4W7JhykXTPRQcP/4aScKrbI/Eo=;
 b=djmh0lgNpU1iJGRRvhCbLai5O766mDPvQPHq16RHT0FMcSwzBEJ94tZ8agt+/cdp/z88Mkn0CeaKU0HD0QeVums+C6rTi4VLW1XT2pqHmvoC26k+IhXtFiZHZKHS09kp4EPFWIemmuNWcX3hNbyb7gd7cRkMjNVJjBTWcFHH1LwBTQWYNmoTBjMUojfvf528DkmzSPCaa6O7uk3gI/pgRy1nKSuXDScaFO0VEQBNhEloHv99D8bD+c+ehQNdu1kZGtA5dSM5w+T4xgnFvogeFIbmYrsTLkhpJDn0XE2fxnOcIqWajRhuOFMiaNsAsPZENBPj/K8FmxYzoyvc1VKi1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=thelustrecollective.com; dmarc=pass action=none
 header.from=thelustrecollective.com; dkim=pass
 header.d=thelustrecollective.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=thelustrecollective.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uonq5BUAXpqBtrlun4W7JhykXTPRQcP/4aScKrbI/Eo=;
 b=pICX6pi5FqBA5PrthsBhnxZAMb2PegQKx76MHFYASS+Tv4FZxINMF6G8KlpgrTXTA982rxtcunryStJNvkWvRShhvVGhstUbZvl7vL28IKvQPOFw/x6tERQiKMP7CrD2+bUoY28yMV6mfub2JhVqOGc3uzzvdDSiTDqcRhh4apVa+be8ojgJmkbuvQgokzIO0GHMWhjj+cDmDuZqBtHN5zyZIKyFCnSk4V67hfKrln+uF4hZm5w2KXQ62DEYvpya0iIn4DDcLJ3tksmrfaiJMCD/Lj8734nAxhHzX95mc+hTRJq8W2x2UV3M2vfBTW3JROSxUKXSA86Qm7TQFtwRvw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=thelustrecollective.com;
Received: from DM6PR04MB4682.namprd04.prod.outlook.com (2603:10b6:5:24::20) by
 PH0PR04MB7333.namprd04.prod.outlook.com (2603:10b6:510:19::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.14; Tue, 14 Jul 2026 04:17:35 +0000
Received: from DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee]) by DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee%3]) with mapi id 15.21.0181.019; Tue, 14 Jul 2026
 04:17:34 +0000
From: Timothy Day <timday@thelustrecollective.com>
To: Theodore Tso <tytso@mit.edu>
Cc: Timothy Day <timday@thelustrecollective.com>,
	linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.com>,
	Marco Elver <elver@google.com>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/9] ext2: fix ext2_xattr_delete_inode() context analysis warning
Date: Tue, 14 Jul 2026 00:17:24 -0400
Message-Id: <20260714041724.3186239-1-timday@thelustrecollective.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <alWJFP2k7bR8REK2@mit.edu>
References: <20260712165610.366474-1-timday@thelustrecollective.com> <20260712165610.366474-2-timday@thelustrecollective.com> <alT2yHlfzhTZ9n4T@mit.edu> <20260713164417.350710-1-timday@thelustrecollective.com> <alWJFP2k7bR8REK2@mit.edu>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR06CA0028.namprd06.prod.outlook.com
 (2603:10b6:208:23d::33) To DM6PR04MB4682.namprd04.prod.outlook.com
 (2603:10b6:5:24::20)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR04MB4682:EE_|PH0PR04MB7333:EE_
X-MS-Office365-Filtering-Correlation-Id: d7ea66da-9186-4524-33e2-08dee15ed498
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|5023799004|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	H/xkMInzXflECf6npMCtllS+Y40eZW8Vi0FdD1C95hZxOegKYzcXUgy7JvX1ONYIX/P9fsna9U8T+HdRFJ+8uCtj9n5mHa1L+A6CXlA7qszIXi3k1n9SDpIRAACbmZjXp82nVtkeRh4gNaraGh/zOJtTdq4myDJ/2hZBL9x/3y1zbjj6OBvy4ZJA8lbf/7LmDMX+quQSHvWeRKlPDM/hovFJl6nugvMIk7AIH+K7H5gPyFrjn1sLtnfaiDCZr1k2lbrffTWZRlDtiPxoRpVNkNb8RVzH2/VureSUnnJSrSQyuU+0nbw83jvV3xVXOaYjD8SKf088V9migHGuET5dVLFV4Y0Q5Fpmjg9QLNS/oM8Eq4EjW0QLuEeEaBFSaNkVTIsN2Qygc/SDAksYKWSpFWg6EX8ZTpV6tfND4dhw/2eqsIrSQJgHK+LbyFEq5UB4rkenp/uHvRbcRfv/685Ja2t+LZ7xns1hUcbnVeTINuBKxNC+0VgfqEoFNnwwpuEt7IcXtclhtL4occpKzMe0cCBcyfgtCL9BFfPySfHcBUhQ8WL1vRJwrj15Zfa1ZUlLYkvX5E3Q2g5oLnLOZoqehekEfRaYfDlUL6SRK+WXO3Ff+r1uZFN5JaChXfBpRrEgkEMCSEhKAFwFNOfqVJdxsaDa4JvJCPxsL6gU2ARuZ7s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB4682.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(5023799004)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?u/c0Eh7sjyiKgXX098uEYYQjgqlE4u+9IFruu1CWZYGxG9K5Dzxc+zdjMiia?=
 =?us-ascii?Q?zV19j0wZFdIWQzs2z5FRbpsxepKEd6PpYRXkz1hKMSVb72h0E3CD1PAavmte?=
 =?us-ascii?Q?1P3uQM+BEJe4Wbh4FP0J7Dlnfbbls0WkTzfdS1YYL7vI+S/E6HiekGaTyl7F?=
 =?us-ascii?Q?B2/MiIRKiIZQctdapNUdfyp+FyzgPsOX+C1mCwBmDGa855H36BOdILnvopmO?=
 =?us-ascii?Q?nKM0cOTG7XqNoHn8FQnrXSSHs8iwtVmb6nKsYFkhqSFWlx8cYS6BdjtMkV3G?=
 =?us-ascii?Q?7+DMiYBdUAKBR9B/SCAlm44cCbKA13NXYHeoRij2cowHuBGetMgIDFjgrNbD?=
 =?us-ascii?Q?o3jz8RA7Xe2nNLMCzJtuE7dyvaqJcWcxeUN5CipzlfUV6FcmzmMGU4CQHFPn?=
 =?us-ascii?Q?haqmIGArvH0yKh2RplM/CYD8W2s4RBPzdfAYZBGRzFrE/HaE6kBc0oNnPzgy?=
 =?us-ascii?Q?67y2q8mgPkBQQyYwSMczkiVdpDLROifPOmhWhj6ok3Cnv1siqrp0l6A1YKi4?=
 =?us-ascii?Q?jNel7hVowWps72ORaGpOquaEEKiUdBNDxWBXjslVaaev/VLLlUDN2pVk3zZ1?=
 =?us-ascii?Q?PxyUmL+m+8LAdS/SL+R0nzmqN0cuEB56KUNX+/DL8UIBlhQhIYbKtumbSMCf?=
 =?us-ascii?Q?YJfXzCk1hY/mRrEmr+5wsUZiu+Kqh/Qe8fHSXHRJGEs503SzCQTdq40MtZyf?=
 =?us-ascii?Q?M6qaITjG5zmdC50WkmeI12cDL7shf//9ScGQAwSkEhpyDLgGWmUH/8F9pXw0?=
 =?us-ascii?Q?yXNxHRhwsPn/1XG3n/7USap0iueMJQL9ADEogkx9KbFteN6ZL6LRCQSv3FzZ?=
 =?us-ascii?Q?aQINeYbkSJP6pNyUd1h6hW6zwZHd9Wk/TYPFbT4t9dWN0GV1ZOi/Oc1ySGmO?=
 =?us-ascii?Q?ueBmEhw4GMXWFlK2l6nMj0+tMIOc3COdqv1rI2l2RJnJ7EBC9fEtswE8qGhD?=
 =?us-ascii?Q?CpSHsRemaeD6ZkGrJljPkj00Kd7CdazhMo+ONVF7d5+zL7qLwjG+VuGmO1Wd?=
 =?us-ascii?Q?9u+1bWgGclFMWyYIleMAyhfmCTQGHS4tCifp04pfybuPYhA9wXyOcnGotLnL?=
 =?us-ascii?Q?CsfKcjoYhkilPOb0g8y5AGw9T7ZiYceCXM+I/7ExRmqqeLfSp+NEWltuklH4?=
 =?us-ascii?Q?YND30+tsKtpvIM68Oavpr6cjaOyyQqNXqFjUZQCXz8TnOzFvh1D2c+SWmX6C?=
 =?us-ascii?Q?hcaQBt0d3adSQLhcxOv6d3FvNsQV+8wV/8l3lYn1l2/8JB/gqiN8PW6tNMyf?=
 =?us-ascii?Q?/bCr3hIRQJBM594Y5iuh0xQtNEqf+UoEnE67UmSr+MFLj0rg4WRd9LhKlVQR?=
 =?us-ascii?Q?Sa9XPuYp/w/fjJKlENR7BDbnv210L8IfTJDEDbKshXyPC/VvFndNItaPQN6r?=
 =?us-ascii?Q?pmDm0tXysoi09xhQjbIxHW/H8WJDaoXEYLJtScM0OKv03yV7AEgD73ubc1Qb?=
 =?us-ascii?Q?y5zQDQarrtkgdhOILsgskhq9bRQt/mTo67bOJFxIILUwxRmRycb2R4XXrjup?=
 =?us-ascii?Q?UOBnY9jKlpn/dDwOnGJOQaZ9TGHNnI1cyukZX6RdEOhfOlRC9zkSJwUTFDlv?=
 =?us-ascii?Q?lB+1MTt3Q05HVq7FReo0vpmA7hK8/Sie+2A8E/QgERBn2XvRny3A8Bz6fcdR?=
 =?us-ascii?Q?iRZS4N2ecNAib3RCMMHR8fp5c6G1mNh9uUJFrKb9+z+Cz1OjcSmDaZIPTag0?=
 =?us-ascii?Q?4pm3ogeevg+lQ8Nos4b70mtnCZsgF9oHGYyRsIrkbuHAorZkV73mxOjvFG2h?=
 =?us-ascii?Q?HQzk2H0YdPLs9lgxeeKxEGP/88E+DWI=3D?=
X-OriginatorOrg: thelustrecollective.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7ea66da-9186-4524-33e2-08dee15ed498
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4682.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 04:17:34.4992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4c9dec06-8f2c-4233-98d5-ca3cb36218fc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ED7eiirLLtPnIFnycdmrv5FXDPt41LIYlpFAiW3PyMjC3x6rAULcKi4XrQVoAOY4sxtGYTx4OMyGrvL64VLVcCFImQMUi9mV8isE9JfE3DE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7333

On Mon, 13 Jul 2026 22:26:02 -0400, Theodore Tso wrote:
> On Mon, Jul 13, 2026 at 12:44:17PM -0500, Timothy Day wrote:
> > I don't think we'd want to disable unlikely() globally when context
> > analysis is enabled. Only for cases where it'd conflict with the
> > context analysis annotation. Long term, I think we'd want context
> > analysis enabled by default for Clang builds.
>
> I see that Marco has a potential change to make LLVM/Clang to handle
> this better, which is great, but I'm not sure why disabling unlikely()
> globally when context analysis is enabled would be that terrible.
> Context analysis wouldn't be changed with or without unlikely(), and
> if we use context analysis as a debugging build pass, we wouldn't care
> about performance, right?  What am I missing?

It's mostly convenience, I think. If the context analysis could be
made to work without any runtime penalty, then you don't need a
separate debug build. If you're doing a bunch of kernel builds
anyway, that's not very compelling. But if it were automatically
enabled whenever Clang is being used, developers might catch these
issues faster. They might not think to enable these warnings
otherwise. And if distros ever used Clang for kernel builds more
widely, they could enable this feature by default. Then
out-of-tree modules could benefit from the feature without having
to make a custom kernel.

Tim Day
