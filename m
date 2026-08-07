Received: from SVZP279CU002.outbound.protection.outlook.com (mail-norwaywestazolkn19010000.outbound.protection.outlook.com [52.103.52.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E1E3DA7E4
	for <linux-ext4@vger.kernel.org>; Fri,  7 Aug 2026 10:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.52.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786097024; cv=fail; b=bK9sG625nTUYrqDhuDNY/5JlHscSSQX8TUZW0IcwO4fh/QO1hJVXLco1FXArO1KqQftZUzoZCknPIDdYaVAdaKYv5VySWh7x34wp1eaUfsAoG5+OQ19noPt4JI6/h4kfHx8bsTPtx8fIhjNpBr/Nyt1qa+BlZJ0WdSTVwwNuSoo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786097024; c=relaxed/simple;
	bh=F3zQKGYygyMY/k8xAjM6yYAJUYnZAVa/pHUZcUmUJSU=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=RGXlgUsKcayXcYFyufTU/wLoc7hwHzRD81kbLNGVlFAMcTeyA/7LBq7jAQy43sxSnl7qmOWCQz+E4t7TOtItM8Mw6fUsSNd+FEXD9xXaQNHg0MCFnDY39lNOg/EtzsseVt2UnZLVjL/6muAK2Lrn2mqK50bEvqZt5zjZSMg2jL0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.de; spf=pass smtp.mailfrom=hotmail.de; dkim=pass (2048-bit key) header.d=HOTMAIL.DE header.i=@HOTMAIL.DE header.b=iCnwLj7n; arc=fail smtp.client-ip=52.103.52.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=HOTMAIL.DE header.i=@HOTMAIL.DE header.b="iCnwLj7n"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GlsgMtKsrhH/t8rK2qrS3qmErNG3YAlkWAu6xuZPNx5EIgEEvko5yALv4CoL3pfyvVKsyE+IcdBb3xevjTloRY+Ku5Yzeux0evSLZkbLJ6CnXMjXELonA59SJnBLWVAdnD2sk+ulhcWOc+ZVVGmRjK3yov9kb2xaqMDB4/gNtuk3OEGXsaucivSJoIfLHM7gj9+JEStxW1Sf2N2ZpXdk5zX4hygISa8VgId8ooADrJ83ByJrH3O4xN6sn0qhDBoSgeOr5n2bN2FxdLXEidzU+G8jqCExiMgZ8pf4u7923EjHCG056DxkdDTmQjJajWb4BU8BfgMIMcyTSsDVJ7NkwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0wU9rT1Y3rdBnrinyKKlaU1zrq56SEBL25584foUnqA=;
 b=yniscjTs3x9u/hZg6lt6j0+e4ieFuJSjwW4MiaaQAfRl+HsLL3tGIn36A7CR7PkpdEsCmhS6nldPexeyxukGvQilpYip6MjarXJ/xRB81sVWnPPcuO85Sy9XW65IDGMViplC1O0ZqmK5KjXFYWqEgTzfKcGKRfYJrVoO3QUBNyUQNUqaEhZXzy8+NSBiHeap+a8MvAQPIsxHM1O9FnJv8nd5hXTBqWrQ7wpJVfIbis2+AINjOE6r+xp6HtUJfuEfBKnQheRfwEP6o0Ni4Tx0mdY7gfO/flRF3/9vX9OTFTExGJCZkL8NHgOouurD92MjSjoMxeKkjudk5tRL/4PWXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=HOTMAIL.DE;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0wU9rT1Y3rdBnrinyKKlaU1zrq56SEBL25584foUnqA=;
 b=iCnwLj7nbbPNiIceZnaWD/XFN94nGeTOQiKx2K6lOWbBYuiLSjtoKz13Y+Om2Strs44vV6Wm1Tf2m1DRzmPgsZtAaQsjVeXYLZ+if8U1oEnlIQn/uMnB9Cx8n5KrAFKnLq+rWqNWaTjYiSEyTlptbV0YvcYQmXKDGPc3djbqmM1IA3n0Cenkejb6CuM3MCWxtwpmq9hQIhZ4Il8YXt1BsNXHEfMdLqchUFArsmDEuoDKl7IqHfN0XCa+21G9S6ryxtrv4hzmfCn6mCklw28PYsTfR9P6Ge/mfBwI9x4Fb5F6DilGVqEn4u6EEyMnV5H60dsLdI41j4RqfbiHJl5pNw==
Received: from OS6P279MB1180.NORP279.PROD.OUTLOOK.COM (2603:10a6:e10:70::8) by
 SV0P279MB1103.NORP279.PROD.OUTLOOK.COM (2603:10a6:f10:32::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.23; Fri, 7 Aug 2026 10:03:39 +0000
Received: from OS6P279MB1180.NORP279.PROD.OUTLOOK.COM
 ([fe80::8f31:434c:edb2:d040]) by OS6P279MB1180.NORP279.PROD.OUTLOOK.COM
 ([fe80::8f31:434c:edb2:d040%5]) with mapi id 15.21.0292.022; Fri, 7 Aug 2026
 10:03:39 +0000
From: Nexory <St4yl3r30@hotmail.de>
To: linux-ext4@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>,
	Nexory <St4yl3r30@hotmail.de>
Subject: [PATCH e2fsprogs 0/2] debugfs: fix rdump path-traversal on untrusted images
Date: Fri,  7 Aug 2026 12:03:02 +0200
Message-ID:
 <OS6P279MB1180ED8E849B4768423DCF8ECBD12@OS6P279MB1180.NORP279.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.52.0.windows.1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0107.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a3::17) To OS6P279MB1180.NORP279.PROD.OUTLOOK.COM
 (2603:10a6:e10:70::8)
X-Microsoft-Original-Message-ID: <20260807100304.2032-1-St4yl3r30@hotmail.de>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS6P279MB1180:EE_|SV0P279MB1103:EE_
X-MS-Office365-Filtering-Correlation-Id: d5619fd2-1bb1-4ae7-2558-08def46b277c
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|13031999006|16041099003|8060799015|19110799012|23021999003|15080799012|24021099003|25010399006|4140399003|5072599009|40105399003|53005399003|2607281247196008|3412199025|440099028|260806224601699003|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Is424rLZm2PvCC8TBKyc2CCOJJe8mI3EI7rsKTOrGOnKK3Wd8yuBz7S7cdOB?=
 =?us-ascii?Q?D3EK/UEml4MkWDJYS+mnaLG5WKW70JGGYVwuTpUffoIp6p0Jb0xcWZ2sl5Nc?=
 =?us-ascii?Q?WyeNLDMnoKhmTirIYdeiodh0BUqT4DQhN8MZgSqMdoUDu6mGoarNHFR04uJa?=
 =?us-ascii?Q?omez9oXTj2JfYNucr8iwqWroz5IyIoLkN83MI+SV3hnMP1dWjb3bhi+NZDTG?=
 =?us-ascii?Q?UhjsBpnDQoWKol6FOv8u/0pTjW5eqbigJHKe+pt+yBoa1QvxcKL4+UtIdwJW?=
 =?us-ascii?Q?mJgTr/9eE8F+JvZgSztiG3a+NIwu4ZOu+zBP66pMqGa8bnCLGDynx4RsHjs5?=
 =?us-ascii?Q?Wf72Eip6NpcyPfzrzbpSDiIohebPcFS+00bn0vgQb1qfcNtv2tf/jUawoihk?=
 =?us-ascii?Q?iuhwvQu/wheiruoFF+b0OHFhZ1MHffEBR+wl4fg/1Wmk/S9ZctYnwl3A+YdZ?=
 =?us-ascii?Q?+N8AUOrNE517d8pW9/V1cG2Qazx2LYqViLomvFU0P1a0IioH7HTkj6qL+++J?=
 =?us-ascii?Q?rrijvSBy6mq5muBz623jpsdAv4uDHd45sXbodL/NhK04vWjPJ9iEppwWBd05?=
 =?us-ascii?Q?JCYWwLZURuiNZoFRclJy6B6zja77mKkz5WERTj/YRmVbTiSffO2kN/+3ncps?=
 =?us-ascii?Q?UmiQaXMXRqJ/luE/pTbk7xj1HvgYngybi+fGv0tGkMWyr5ysjxb3bVOEy3Qy?=
 =?us-ascii?Q?sRJunpXwGtu/yjy1f2lxTxfIRJFoEeoyL+soI5sZ/9esRJzx4ttoO/GNx/rp?=
 =?us-ascii?Q?aQJq7H++CkO8a04EMUUhys7numVO5TczM/aMmtL7qORCGbyZ29C7B8AkM0V1?=
 =?us-ascii?Q?9MKs+rXgjHi/pepDFAZVUFp+eS6HJvbFU3Zx6Yp9jvvyOyTfum6ibBl8moNx?=
 =?us-ascii?Q?RRuKK1Ukb5XMkWHYBeDLTj5ch+J4vFmJp/stJGsJrlJpTxTgwTXo6WLvCcbL?=
 =?us-ascii?Q?GeqpYlDxEFijMWYTBP3P4tp1TXKP7luN7LlwvNzf3iZKL96RvP3/5LbzsOO7?=
 =?us-ascii?Q?6LPPTtVev3q3JctIqHjXRoZP4c3gndzcXQNnGCdXeiGTzpHcTusagKQtBrNK?=
 =?us-ascii?Q?sud2VRI+PFBq+SZtEzKUgYmiYHjwmQ=3D=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zGxqsxp7SZVvPNuhZnpNCA+5ToGGNovGiff1LrRBzj9rxtMwbxTyvsw83Vdy?=
 =?us-ascii?Q?JFIoF1PDlaNP0PmOQJ7l7MZKYqm7S95AwxGa8P2myFtAG1F1HHWIVP+VzTYo?=
 =?us-ascii?Q?7mgOOcZr/Ijf1r0UYKrziSKPmYAk4zu6Pevu3Wj4ut8dsx6FZcrk9VaVeeGJ?=
 =?us-ascii?Q?pKRRcu8obfrKcJncjNuuvtBLM/M4Sx8d8sqmZbflcdGK8gxaoeZoluuZZbGG?=
 =?us-ascii?Q?ESfFIy91rLExeb3w32o8E9xIHdEnudYC5/PGs9o+R264WClPMA0azemHQJLk?=
 =?us-ascii?Q?cj0MFK+6p3jtHpCLav8wKiOa9+kMf9JGbcpgDfoFegik7E5c/w72RyoGL4GA?=
 =?us-ascii?Q?Yx72dTB+F+TlyQmOzxL9QncNimKOKMnlnQBS6qO2uaSd8lXq/XweS8nlXscS?=
 =?us-ascii?Q?3Bu3pxYSIPIHUQSWhIeSSDnLJ01okt4kdkERBgBkBpcjHxMJm9SfkWeWIc1N?=
 =?us-ascii?Q?wG3nQpR07cYDT6jKY787fUQ7+HX4iu34Wwd0eqAMrN9vVWvN4aU9/+DHpoRk?=
 =?us-ascii?Q?wWFRQs6mjI4thg1MMugnW/bGxzdYW7acIEadneFaD/2eqcRlPwGD2mkBonbl?=
 =?us-ascii?Q?MVdRb9S9xEiJx54AMCEBRXAJaB5YpkVLsGKNgJOnVHRDCEW19JBQvkh1R3eO?=
 =?us-ascii?Q?7fiiP8hXXioN+WnVScY09SUrQhMEjwoKAgnQQ3hXIeCxIAhDI4IaooLbkHA5?=
 =?us-ascii?Q?drxQmCdUAzn/6pETYJ0+3j0HlZ5WsOAnhn70NbeK2TZbsZwzWBav2wxuvlrE?=
 =?us-ascii?Q?BiBTfyflo6bnOoqJzJb9oVi15C8gXu86c6nS3KKr1LYRAWXOBtmZTMkAwGs1?=
 =?us-ascii?Q?cOOGRZ95vqjY2islQgCMNvvPTpsIKvvdLcrJxXZosd53ktf1Z6TNE0/lTxQ9?=
 =?us-ascii?Q?7YW2gilzH6x0y3ySxEdCkwHP9ffiiAu8Qso/OQ97G9NyXF0xCkX7LgPkhbXz?=
 =?us-ascii?Q?pQ7wJFBqvIQPRen7bfTiFH3jchfrxptd6oAi4NQ/9e4b3rA+uyVzjNXrN+1T?=
 =?us-ascii?Q?JM+IZ0BlCsGHza+awHAl/Rebu7EGnU/eD+Ncw2oSJXuXs9YODby9dNNyjLfB?=
 =?us-ascii?Q?xMUwnyaIL+plmMH9EPpORJI0GEak/b8hj1Xoz1vpPD8hocWe7wb7ow0aKWQB?=
 =?us-ascii?Q?Vx0jYP/r4pE0CZ1WRFidyUtGjj94SBxPyzkePOKQ1M8GN5+qVjPZJQ9hC+yQ?=
 =?us-ascii?Q?y1GI1NCVJQaVoC0Gifc6qDogkKTFk5l1KAQyjze5BpRl+eDk03MxdsJ4PXCr?=
 =?us-ascii?Q?z4XZKI6xwzNElRV+cS5aru2weioyQa/qMH6MA2IlfodKeBmQbOmdnUTWPkDU?=
 =?us-ascii?Q?DmmipvOWgeWGjraN63pB+E4aL6PeOtTSKw0oTf9G0U7LymrP8OHNfurRsX0Q?=
 =?us-ascii?Q?7//k37Qaz2czwHo+xTwpKMdns4Hn?=
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-ecede.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: d5619fd2-1bb1-4ae7-2558-08def46b277c
X-MS-Exchange-CrossTenant-AuthSource: OS6P279MB1180.NORP279.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 10:03:39.7188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SV0P279MB1103

debugfs "rdump" extracts a directory tree from a filesystem image to a
destination directory. It copies each raw on-disk directory entry name into
the output path without checking it, so an entry whose name contains a '/'
(for example "../escaped") in a crafted or corrupted image is written outsi=
de
the destination directory. A valid ext2/3/4 filesystem never contains such a
name, and e2fsck already flags it as corruption (PR_2_BAD_NAME), so only
untrusted or damaged images are affected, which is exactly what debugfs is
pointed at.

Patch 1 adds the guard in rdump_dirent(). Patch 2 adds a regression test,
d_rdump_safe, which fails without patch 1 (the entry escapes) and passes wi=
th
it, while still dumping the legitimate file unchanged.

The test needs a directory entry whose name contains a '/', which no standa=
rd
tool will create, so it ships a small crafted image the same way the f_* fs=
ck
tests do; tests/d_rdump_safe/mkimage.sh documents exactly how it was built.

After applying the series the binary fixture should be intact:

  sha256sum tests/d_rdump_safe/image.gz
  e304c8fe87863da197d2565ca95599c5dca2fbd22640aefcf70258d6935eb922  (922 by=
tes)
  git show --stat HEAD    # patch 2 adds 5 files under tests/d_rdump_safe/

If that hash differs or files are missing, the binary block was mangled in
transit; please ask for a resend.

Happy to adjust the com_err wording or the guard's placement if you prefer.

Nexory (2):
  debugfs: reject path-traversal names in rdump
  tests: add d_rdump_safe for the debugfs rdump path-traversal guard

 debugfs/dump.c                |  10 +++++++
 tests/d_rdump_safe/expect     |   6 ++++
 tests/d_rdump_safe/image.gz   | Bin 0 -> 922 bytes
 tests/d_rdump_safe/mkimage.sh |  55 ++++++++++++++++++++++++++++++++++
 tests/d_rdump_safe/name       |   1 +
 tests/d_rdump_safe/script     |  22 ++++++++++++++
 6 files changed, 94 insertions(+)
 create mode 100644 tests/d_rdump_safe/expect
 create mode 100644 tests/d_rdump_safe/image.gz
 create mode 100755 tests/d_rdump_safe/mkimage.sh
 create mode 100644 tests/d_rdump_safe/name
 create mode 100644 tests/d_rdump_safe/script


base-commit: 43643a57fb2d3368fbacd181a8cd713102d52a1a
--=20
2.53.0

