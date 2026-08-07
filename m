Received: from SVZP279CU002.outbound.protection.outlook.com (mail-norwaywestazolkn19010000.outbound.protection.outlook.com [52.103.52.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97144052CD
	for <linux-ext4@vger.kernel.org>; Fri,  7 Aug 2026 10:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.52.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786097026; cv=fail; b=o4EcGIC3ovPTO18mIVUfVkaLGWwR+rYplIHWsSYDcWGAvbnYjtmYFR+LdjRbzdF2c9fM5E1kp98PORGam5yielqrtmCJu+fiB9rjgMEuVyXUepYR2h3uqWss4zxO+zCrMCqW/rj0BYrrqsWha7y62tAK/bvfwYcFbQIiN4OrIeE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786097026; c=relaxed/simple;
	bh=snjoXODVO0nEbX8+N8y01vIYUPZRs4MSlQiuLd/rmP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=C+LcApROlYhgOfZxnBnl7bzdJG/OUTBY/BnD6r+zqFuKhkGVgmMMDA7faqI5jm5sJC+F/ULOkBkX+dEujHwVcEFP4qRXV0w1PX/eZih93/lYWi4JeDyMDTZZHTk0z78jMaZyic+buHLs8eHndmok/LeIm17kMp5YrRhZnnnzfNs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.de; spf=pass smtp.mailfrom=hotmail.de; dkim=pass (2048-bit key) header.d=HOTMAIL.DE header.i=@HOTMAIL.DE header.b=gBLKjmPa; arc=fail smtp.client-ip=52.103.52.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=HOTMAIL.DE header.i=@HOTMAIL.DE header.b="gBLKjmPa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OkBMBZYtZsZMTyaKexN0v2NZ8LZvihjzJWNI7rWhDXehbhFKV86m5aiPLgvQGVHja7VWiksY1DiSSU2K8Pz5XFCAunKbWfCdH7EwZdl3nQEzpLx1KUO9PIW2ETXNwstAOiPvALcgdJOQQ12CmF4szf74i/lSe7vnw7JwGWuLSzTegRf8IQykBMmDffK15D+IZtaGouG1Ts9BIGygHk/m+8uD3x6Qu05JCQePNLEwi99P67wuAw1ecW1FtFCYPZwjmVpLYHLsLCOTijiXdW7LF14TRDuviIAJxkODhYHrywqRhMDeRHH6RTo3pvCFs0Q1wUlSgwWK172pBrabg/fbvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DUQaYv/GAvWSKyVpdn21/XRXt8qXThNkikrMsCEhsKM=;
 b=kUE5FIIeAXm4A/Xd9zr8i0CuBKNitFW5vndBu3Fv9uG26a4s6SaKYvQj/odEAIcpf2hFaJ0fuQF/Lz5jPIMMLaJ7TYTS+Jrn9yZFkr5av4Zdki87N5n8OIO/QHA0KMJuBQp/fk6V7u9N7kuZRF+gE+oXBSUXuNWJm5qLBkE163NEB+VrmH5SHEDbmdDdgSJOO3p+aG5hDX2XQrPYtcb5dUI7DdDs3KNkhewXA4lxNhxJ8IXSvaqOm42Gw/gR81uHr8ndrcnm89r3KMIuS3e5OQmaY9O9KtWqbalWb1LpywQx9XTpzLmucX76Ik5W9aX1Y1L+HWoMEOmaVDKrtknBlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=HOTMAIL.DE;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DUQaYv/GAvWSKyVpdn21/XRXt8qXThNkikrMsCEhsKM=;
 b=gBLKjmPaKKwWhmyuZ5AEyjMQ7T19b4CgXfObhddil2uolliamxxREuTvW8T45A7t+WNGey00hdN1Zl1i4stqtslSNZzjew18iHgTZL2L+5h2YNumXoXnmb11wrTOxEhYZKwwH/wzPt5W8zaAk9NSTTpYA+CepVAhC10Ox+htKMJrIz86RWHaWIqFYj3Ic3Z+mJS3QPUmSOW29sfFetIMYnkROf3+2eo6zC+E7L5AvD44+pwVD81TMwmkuaENV2p1RjO87q4KT6wFxpCTszJKj5h0Ntn43drwXN5G+TSp+dQOgSpEREV3H18HEukRXKh1xZ89QSbPTlbABQr/dTEtGQ==
Received: from OS6P279MB1180.NORP279.PROD.OUTLOOK.COM (2603:10a6:e10:70::8) by
 SV0P279MB1103.NORP279.PROD.OUTLOOK.COM (2603:10a6:f10:32::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.23; Fri, 7 Aug 2026 10:03:40 +0000
Received: from OS6P279MB1180.NORP279.PROD.OUTLOOK.COM
 ([fe80::8f31:434c:edb2:d040]) by OS6P279MB1180.NORP279.PROD.OUTLOOK.COM
 ([fe80::8f31:434c:edb2:d040%5]) with mapi id 15.21.0292.022; Fri, 7 Aug 2026
 10:03:40 +0000
From: Nexory <St4yl3r30@hotmail.de>
To: linux-ext4@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>,
	Nexory <St4yl3r30@hotmail.de>
Subject: [PATCH e2fsprogs 1/2] debugfs: reject path-traversal names in rdump
Date: Fri,  7 Aug 2026 12:03:03 +0200
Message-ID:
 <OS6P279MB11807BB1AB25D78C31814B39CBD12@OS6P279MB1180.NORP279.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <OS6P279MB1180ED8E849B4768423DCF8ECBD12@OS6P279MB1180.NORP279.PROD.OUTLOOK.COM>
References: <OS6P279MB1180ED8E849B4768423DCF8ECBD12@OS6P279MB1180.NORP279.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0107.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a3::17) To OS6P279MB1180.NORP279.PROD.OUTLOOK.COM
 (2603:10a6:e10:70::8)
X-Microsoft-Original-Message-ID: <20260807100304.2032-2-St4yl3r30@hotmail.de>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS6P279MB1180:EE_|SV0P279MB1103:EE_
X-MS-Office365-Filtering-Correlation-Id: e68951a6-ea32-4bcd-a5b0-08def46b27d5
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|41001999006|13031999006|16041099003|8060799015|19110799012|23021999003|15080799012|24021099003|25010399006|4140399003|5072599009|40105399003|53005399003|2607281247196008|3412199025|440099028|260806224601699003|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vR2a4DhgswJ/FEfd4EVac/ZYLRoSO2XAZZKsV+UUxZ6YH7S9G1ngS3trlnCI?=
 =?us-ascii?Q?LocSs9xK+fmym/EubBr7/dzlVx1RfeDpo9OlfF4sf8FiiSrB4JQ7ZfMrSAvT?=
 =?us-ascii?Q?5HPktFSNOiIf+mzBStK+bG5cmZUTvZOngsJq/kGLxacKpUQOLX/GJo/+GE9z?=
 =?us-ascii?Q?ESYg4225cb6ul2XVdYmR4N/GStYKSDA/tirQ1SAizG3w4Bc6V+UHUTwexv/X?=
 =?us-ascii?Q?JA5TMiNkeQmEQJXDg61m7kzNY6juhKgXpfpwS0gRwiC02rtxJSWkELfRBxrD?=
 =?us-ascii?Q?7A8fiIPrJkPgyijsUCKI/7fh+Mw/zXbP42UfmPksK+wYxRE9MKk37G+WLLjm?=
 =?us-ascii?Q?2t3du2+ee07+hrSa8dzbouhQcbXnZxIIIyxv9HTUT+pqXyItZ72WkhoAFhR7?=
 =?us-ascii?Q?lB6o0IrIc1IQGvh9qfJffFaSwhMnJlCky2Sgy0GAIr51+5dlcmnqdsO0HLWU?=
 =?us-ascii?Q?3OMiNutCHZMmL4ydJQh9hcCC5zmShpkqYm92TATqLWMaO2yWQYkE+RTvNtkq?=
 =?us-ascii?Q?9XoY56i5LwxoJ/Wm9FZnxq9fUyf4PedzCoBdzzE+4is7jbZvrlGh85mPlgLk?=
 =?us-ascii?Q?zr2mTfUqxuOYo9vkprTwWt+Q4L7boRBiXK9u0Q+H4FIEguqm0n6vLQ/BaHlF?=
 =?us-ascii?Q?8DWT0S838kIaHiUrVfznrPrG7d2+hnENw885PZpnFuADsc0XApAbM4LIoj5z?=
 =?us-ascii?Q?6tF6+oSNou7KNmsT+6VE1+bRfTB7GmagTm1BWCLXjQC1vhqUL0Mkt1hDBYz9?=
 =?us-ascii?Q?6g2EexbgRp3rc53c34el3mQ94wECX7QANafBStIaACFyN4zcTJlJZIAiRsm4?=
 =?us-ascii?Q?/ZiYZeP6Vf5myY/fPBoRXweuh05E7SXt7f333sEhdsst76MPhsiJ6NT37onW?=
 =?us-ascii?Q?32rBfnaNzBswm3XraWWSbhebN6AnnCvhc9fVsCCyJbSzOMpXOgvydlikBfMI?=
 =?us-ascii?Q?oR74e/7y/xoQrWFxdKRaaMg9e0w16/GZAxeM9oHBL8yHv/fSPpcPkE4un/Bo?=
 =?us-ascii?Q?nP1CwjTuh7IXLEFg9jB13meULx+a7xnu7HL0I5HaN7JnPMO/3RJhW3ycR2Np?=
 =?us-ascii?Q?hgv0vdTgtQyblrSFMf0NsNqCtBHTrfmaCpJUj4aRAMSOI6Xlh7o=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+rTyWsO717eFNqc2Nr6nsW+oa4EQWug8KPd+Pl0p1fL7DT6iVE3MhJXTNhuY?=
 =?us-ascii?Q?RBLtpYeUtHifQ6qqaSQmETBkhctNh0g4FIFUauvmqcj0s27/h6D8x9F3kZ04?=
 =?us-ascii?Q?vbX04jViQW81WOfexYjOUNppeWzaiywZAvcUycx9bAl0jfrwrjCg984ADrub?=
 =?us-ascii?Q?eV1NC+JnagT7Z+mJ+OJcF+CU+lIwTrpg7hrLdpWKLrNQ1C84cjPEm2TMAH1j?=
 =?us-ascii?Q?LyNLSEzLXqhFwkdnGa2cuLrLwdwdhxJyuRE7ysMNKUVHyDucs36piczSR1xe?=
 =?us-ascii?Q?Wl5wPq7x/zXk/7Q8zBl+QsOKQoIfOZD353toz71nn5gw7HUdj6Bjh7WbTEUT?=
 =?us-ascii?Q?CXfUEjbxXVFxVwxkHLhTrNDQq06mp+jdEEA7O4F2eZ4xtsPjKcitAPqsZnM4?=
 =?us-ascii?Q?vbCVIg/Tmt/kSIX+QUXKxYpN6o+/LWjgtgmgc57/lCzY38TfzptHZto2CAda?=
 =?us-ascii?Q?1hnDkAtdfR2YGgh2qVteH3K2pvz4HJ6+NTPLYzlC9iYAa58Z3ZbmjJzm/+J1?=
 =?us-ascii?Q?i/YiXMrKs/0NP8oPnyMU/TFL9m8GT6Gkz84rlkv6y98IIPJxJFsswalSTK6I?=
 =?us-ascii?Q?9LzsKmzbEx/tivmbZMJNrX6+U0bST9+5AWmttGPIsAd/LFaqIAM+g55vpqSg?=
 =?us-ascii?Q?ZareBbiquaoA5Ay/fzwV33JL+uebrsu77/NddAny9Wv0j2PBwv11+OiX6JJd?=
 =?us-ascii?Q?iya0/y4jlBGHm1241x/cENtP/Q0BXCnYWj2n3JUB9RYJ70A/XFMOasJxgMMg?=
 =?us-ascii?Q?EtGeG4wlCfi7iaH4KjRzVd2dTnk5ULOaRpHGzEDBSsDEbXKj01qbO1JFJrFb?=
 =?us-ascii?Q?v02WoAG0ME8WKymDJy8zvMs53DHU9pQVfAQIMZBltZOgghX3QPP0i06KcER0?=
 =?us-ascii?Q?wVYghASrRRkd2UtfHxHzjmF8XEiEjsh6neKrWmziyA6DE4DNmjXMjURAk/Yt?=
 =?us-ascii?Q?epET6jjj1fOxeE6w1+oYuEW2nmw8NUd4GvPPlQj+i7abYrV+s3Fvphu1aeR7?=
 =?us-ascii?Q?z5D3qMwf9QXSMLAYbr0vleONC+sRfhDHiA1esg2HvW1cTIOeDCtgCIfoL+Yc?=
 =?us-ascii?Q?4KYSj8gnZpwOCg11lbCljgLLmX6au0KzXAcuAg4PLh/AC1C6axdVNzBcxh5y?=
 =?us-ascii?Q?fZKRLOU/AZOw9AMX+ESRXzmfFEqs/XHOzRITiDDENP/8X/WRKdjZFBGrfSAI?=
 =?us-ascii?Q?R7PydT0IhLA9TNUSo8Vq8buoSZ36AWmqnOuGMZPI0odNwCpIsd8etktPPxLA?=
 =?us-ascii?Q?3cZ/zAgYhc9Qq7Ph/qTHkVdlrVDBCb+mqtsXGZXYGJvfjkqjOplfqqsje304?=
 =?us-ascii?Q?P+fJgSraQpxfpveeJyhko2LtRrJoWYoOlzf8NCsmNuEYkURwaJGAszx5M4KK?=
 =?us-ascii?Q?Tan7HEQeM9nAldb89T96BFQCzeOc?=
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-ecede.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: e68951a6-ea32-4bcd-a5b0-08def46b27d5
X-MS-Exchange-CrossTenant-AuthSource: OS6P279MB1180.NORP279.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 10:03:40.3731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SV0P279MB1103

rdump_dirent() copies the raw on-disk directory entry name and passes it to
rdump_inode(), which sprintf()s it into the destination path and open()s /
symlink()s the result. An entry named "../foo" (or one containing '/') in a
crafted or corrupted image therefore escapes the destination directory when
"rdump" extracts a tree from an untrusted filesystem image.

Reject such names in rdump_dirent() before use. Valid ext2/3/4 filesystems
never contain them, so there is no change for legitimate images; e2fsck
already treats '/' in a name as corruption (PR_2_BAD_NAME).

Signed-off-by: Nexory <St4yl3r30@hotmail.de>
---
 debugfs/dump.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/debugfs/dump.c b/debugfs/dump.c
index cc81a50..e959cd0 100644
--- a/debugfs/dump.c
+++ b/debugfs/dump.c
@@ -317,6 +317,16 @@ static int rdump_dirent(struct ext2_dir_entry *dirent,
 	strncpy(name, dirent->name, thislen);
 	name[thislen] =3D 0;
=20
+	/* Path-traversal guard: reject entry names that would escape the
+	 * destination directory. A valid ext2/3/4 filesystem never contains
+	 * a name with '/' or an empty name; e2fsck treats such names as
+	 * corruption (PR_2_BAD_NAME). */
+	if (name[0] =3D=3D 0 || strchr(name, '/')) {
+		com_err("rdump", 0, "skipping entry with unsafe name (inode %u)",
+			dirent->inode);
+		return 0;
+	}
+
 	if (debugfs_read_inode(dirent->inode, &inode, name))
 		return 0;
=20
--=20
2.53.0

