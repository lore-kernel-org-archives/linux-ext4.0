Received: from SY2PR01CU004.outbound.protection.outlook.com (mail-australiaeastazolkn19011060.outbound.protection.outlook.com [52.103.72.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6681C3E172C;
	Tue, 12 May 2026 13:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.72.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778590997; cv=fail; b=VPJZ4XrKRdiSR9aUz/S+z6BTYFnnbE7Ep6WwcysaSkHzVGqrTNLVGbKLLVMjy9iuJH/s6gZvoR4lMyHAvxEH3qWhQMVz98GdTBXSj/ljavKveiVnKzklQ+SyrJCDBPi2g1zFYG5bg0IxFmeai0chHN96nWDtJBq/XyNdwcTT4gI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778590997; c=relaxed/simple;
	bh=oaTsJSn1WWSf1WPS71n10dGiAarFkEW8/9w5MjfCXMU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XWovztX9mUWtsteoo34BLe1IE8A3SeyZ6Y7zWxdgQY9y9vRHFAgf6q2DfPTpiTJyqt0piwOXDs2cDn9OmjOh6LGdsEIhU1pPcTxoGHELX5jQVooagRVehNby+PHuydUtwgwkQmQElxhMKbEY8OSPgT0x4WGN+eQzIme05rjCdUc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=SSl0E0sY; arc=fail smtp.client-ip=52.103.72.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="SSl0E0sY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VEdPxqKmr+L4JfESPL41/a4ay5JNmR91kNVspec1Wo1hLMqXzad5rca5HrYAc7EKQtN7xWliMMSWWT306vyZ9R/A07LcrqgwmzmlRJI1HRD8QUeAENAKwYqiHkeAXlKk+WB1EVaEnJp0eVVv1cvQZVR7qN8IimWzPqqu4vvdMoPLPo09Lz1B8IRBl1oEWkigDQ9KdWlC0c76LZtfAVXIxDHI6QTyYfLcXmA+mMhYPSmHq9NCC0CaWCSNgvsZPWov29b0pZHIHRaMIvJ4W6JHrGueEfLcqeD8DbvTcA5psenf30KcEwv22hknoB17k1N6G5OrIaKVFImruFR6Azw8lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oaTsJSn1WWSf1WPS71n10dGiAarFkEW8/9w5MjfCXMU=;
 b=xNcoQuORmaWvxmel0hFM4Nie6BsGJnJij2Y5Iifxtl73xJSZG39IIzWbQs+qf6TRFImLXUWhKnOqiPCMOvhElHsU2XDTSvHIMJhEyRjhk6NEciIo345Z86X9WB3GVOOo1hwuAPkDEzdBJD9vTL2xm7vXOLCsczobkCZjOD1gClxC/Xgd8klHskc93H+Ylv98Wra4aGR3rPbl3K1LW44cpjBXe3IZB6L/+UC2ukTopAwEPSXXN0I48x4L8mx7MsHVNpCL5vFrNOAfHB9FC3Ol0hmHwUJqKQPgIDHi+xfOf1Z4xm6+sl8gVwDHw0PNxbrBpJBMiV4XrcD4lyiBv/fiQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oaTsJSn1WWSf1WPS71n10dGiAarFkEW8/9w5MjfCXMU=;
 b=SSl0E0sYIOGXZ6Odf4bdi1gkeCRqnidellvkk8HavjodYax1C/EmGZKvMYQK2K8w46WYMV6QQOBMXKSchZJP7LEhbSiwXIquYHBuqGdtdwB5Fb2bytuzcq+UaZnw0E2OTc9Kw0Jhaqxf0+TjDfTCWOgD64Vgp26kejUytv5AFZGcCWl788afK91YN1NLn2K4/ks7clcUnevPViWCP5boJSe2wanx3zbqjcJUIb5EvnL9SzdkVwvJfiA9I8NfGVyXh5oFZVID1029r/zvEty4v4a47H9fDteIaIWpjgFy30S9LUlQVH0JDhBnTas28tljRamkL4Laf30yDsmWI6Pf0Q==
Received: from MEYPR01MB7886.ausprd01.prod.outlook.com (2603:10c6:220:17e::8)
 by SY9PR01MB9711.ausprd01.prod.outlook.com (2603:10c6:10:306::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.23; Tue, 12 May
 2026 13:03:11 +0000
Received: from MEYPR01MB7886.ausprd01.prod.outlook.com
 ([fe80::19df:3891:d8aa:692d]) by MEYPR01MB7886.ausprd01.prod.outlook.com
 ([fe80::19df:3891:d8aa:692d%3]) with mapi id 15.20.9891.021; Tue, 12 May 2026
 13:03:11 +0000
From: Junrui Luo <moonafterrain@outlook.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
CC: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>, Harshad
 Shirwadkar <harshadshirwadkar@gmail.com>, "linux-ext4@vger.kernel.org"
	<linux-ext4@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Yuhao Jiang <danisjiang@gmail.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] jbd2: fix integer underflow in
 jbd2_journal_initialize_fast_commit()
Thread-Topic: [PATCH] jbd2: fix integer underflow in
 jbd2_journal_initialize_fast_commit()
Thread-Index: AQHc4eQkm1wg5P55r0agA0nvRb4rUbYKTG4AgAAPGwA=
Date: Tue, 12 May 2026 13:03:11 +0000
Message-ID: <CCDC32DB-67E3-4AB5-AB71-9A90A318E57B@outlook.com>
References:
 <SYBPR01MB78813DD23B28BD49B1AA1123AF392@SYBPR01MB7881.ausprd01.prod.outlook.com>
 <7cf5ea66-55e9-46ec-8f69-91e80d3c42b8@huaweicloud.com>
In-Reply-To: <7cf5ea66-55e9-46ec-8f69-91e80d3c42b8@huaweicloud.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MEYPR01MB7886:EE_|SY9PR01MB9711:EE_
x-ms-office365-filtering-correlation-id: f5a77815-9afe-4b25-b92e-08deb026d1fa
x-microsoft-antispam:
 BCL:0;ARA:14566002|22091999003|24121999003|51005399006|24021099003|55001999006|12121999013|15080799012|41001999006|31061999003|8060799015|19110799012|8062599012|40105399003|440099028|3412199025|102099032;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?KWkUsdod8uQhU+DZbMhJtoDVeAJckZwvKPAfeDUC6cH6/S4ZRdAH6va0FChK?=
 =?us-ascii?Q?Ig+XEI1AV0U2jiPTFN21zsMZwwAwZRKagxmYHpTYBRwfu3LKrmG0W+dshT2F?=
 =?us-ascii?Q?x5rQlH8HunxOuMSIHhsrt5WqmgnX5lp4mGkzoq/dtwl4QXPLSVqqccTQqPqC?=
 =?us-ascii?Q?BGxwufeX2XEilO8+u0xm8WrEAX3s1SULHV4+gn49k1rkbXl0IYaQq+CK9fIa?=
 =?us-ascii?Q?mgHhZUiFy41xbDLvxY8TbyVwP3kq0i0hRTmAXxbtjAiKfoEv9BNjPzSo9ZKD?=
 =?us-ascii?Q?wU6+S7HrRF2yShQsAygy4JC4YjVgWaLUEGtn298U3MPzQWBVkIv9f0sx52P+?=
 =?us-ascii?Q?UfJm+sIsaSv1tYH++XZQ3r6w/uQTsiYlGL9rZ59HU3VoGVyWpErS3VHCYLc+?=
 =?us-ascii?Q?aX8JFz93kY+0A8D1g9gquLb1FFvm4LBQQRbXxupvcLjNW86xLm5UAIMExfSB?=
 =?us-ascii?Q?jODn8KNMLGdJI42mSWJPLxIFlF9PFfHH+7qQMPx3cxL60oUBs1yr2YKOmk9f?=
 =?us-ascii?Q?QY8FrUUcCUscTfJFOQP8Vu04htHXH2c1IBRmD5NLnoP/OnrYVEEz7qWX1pYI?=
 =?us-ascii?Q?FJOuWWjEkbk+Eu+LJwYhq3QpetcBnn1arqfXv35iplBk/mTTUByvC34v/sPu?=
 =?us-ascii?Q?cJoo8WqWeVwOLRdHGELXtHPZfQ4zyQ/4AV0wh1M5y3+Jjc194ve1+6s8vndl?=
 =?us-ascii?Q?GzO9xSeIjnChtZK5b8H9MJA852COHGNZQHgYnYaaXutuW85cBw18e4xkvxVe?=
 =?us-ascii?Q?2Wke9zJRHxg+yMuezwduRDKB7b5IIRcDbLpOo9NbvM/KvftCvBnxfUeuf4LP?=
 =?us-ascii?Q?f1nUwGSxYPFA737nDe5mE37a1MrKk5JscqZjWyWeSTOTsIlU9zwldW5QZ8O/?=
 =?us-ascii?Q?hwKbSBQcNykKkE8nUTTSkt+NAZSAFn1dxradXggyHMJ71XzrgARbqqe3PW0H?=
 =?us-ascii?Q?0YQQyI8tRwosMI6fJmQdcoX0kD5+pMsaVqC+wwa17sXrsXG9YNc43Rf+5Mh8?=
 =?us-ascii?Q?I5qy3jsJ+t3wavcCPvQ+6MXVITUknqjHW/PZFhBttWDYI/nALgGIEvV6gvcx?=
 =?us-ascii?Q?hgQablnlL4e3nnsZHE+/3dh5hLSaDUWroUhMnTiX7XMtT2WTJ88=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?XhF4AAehrLq77XaaM0VsnCZJQBrYnBJFULChpH+6+iKL9r1jcvOhtFj8yOGM?=
 =?us-ascii?Q?V6tz9tmQ4gCY5OsyMYbnF0ACrES4LnbreE75GHGN8zB9875YUmfyE0+SBa2j?=
 =?us-ascii?Q?ZyfcG7iGzXcC246CmpfsmR8DDTwNVI6KTTfwJmZVnB0DlFgd6rsSZcEVJSrd?=
 =?us-ascii?Q?Nu/kWwyC1VWlYNtlo5+Z7Lfxpm7yp5FdS2CAga7SSJc2tHqi+3MlY3tcviOl?=
 =?us-ascii?Q?0cW72gHv80w93aXQjqtl5B1sb310ZdqfA0YVyMBt4ENoDaj6ZEQXwz+gLRoV?=
 =?us-ascii?Q?fUeIaQBvbNaNKKjSPjkNEusPh+cI/Q3RlFzXC3VrVeYGFDt6FHv57XQ8sSDN?=
 =?us-ascii?Q?UjlGqA6vs4jzxLdXfxoXHw3r1Eo5Am7A7vUpiMEymUUgg/529MX/0ZzeXysm?=
 =?us-ascii?Q?PVYyvJXwP6+G7PR675dRj+jILKx8NsxhGAdKhhknY3FZ/fs81nhSQsQrinwK?=
 =?us-ascii?Q?Or3EThzJnFqXQakvYDQMGw/5P6kp+umK5g3D/YvmOzrZrl76JJksN6fiaJeT?=
 =?us-ascii?Q?7pT0ucxrnN9eed3TyWc50tVOb14SdCwr9yv30yXIKCoMrc//1eDU697DBVjZ?=
 =?us-ascii?Q?MvrJrUuMsTJzVbdp9PO50lx7VKxhlAN7FgNrmRP6cd04c46iYL1BnjMAkOkf?=
 =?us-ascii?Q?E9cR5sJD9G9Mv3SMBgDHL8IbGJi1r3FuwH2PrLzWBjivEUk7qcuwza1DDjVb?=
 =?us-ascii?Q?nwjkXhdaWnXg8KeRi0yuZom7AM6iUKGekmm5/ucneGuAoJc1+Pz6PE29tuYc?=
 =?us-ascii?Q?jSeEVhDwP/sss/pj/QS+rMFbQZyyba9aOtBdMVvaur/FZa5ywRyM79nqsini?=
 =?us-ascii?Q?CAPf4MXZDiJUFS+a2V685bikVfvYs7C6Pm00o7dvI17nhi8mS5a7tvNJtsM0?=
 =?us-ascii?Q?eJSKdcENeQT8/7aKSS+KJb7NsbCwxle5DDQuElCI8BcvRisbHZ+zc9mKWnk8?=
 =?us-ascii?Q?mVVwmqbBq/AYwfBG5Oz9cicowP1h4akGz8WtGPFb2AAD6XDSXyEsOJVCYAwQ?=
 =?us-ascii?Q?jC9mwj7KNzcHiUOrkCZGS6ymCmYwy786rfVez9J1a60DYbzr+93csavYv8K7?=
 =?us-ascii?Q?ayZWuQo/bOJQkQeIAdMZMyWkdiOOb8rVQspuli4v5FS9SH5nVek3+OoZ4fNw?=
 =?us-ascii?Q?0WBTrTU3dMFzbKMDEKbpmimvD+rmO4fke73VbDiJ7lCf3b7t5HM+MDoPRtpx?=
 =?us-ascii?Q?yGgaejhI5U8cCZvSsdYLHIQAPvgLTZwvbgTvYH3BpYBEoQ4UL9cgLRqForRo?=
 =?us-ascii?Q?dL6JblTyx42vWmzADeLbLQR/eBUlIESnWGm8thqlM2aHVuFLqUwAE2l+jZoM?=
 =?us-ascii?Q?0GgcvmHZOr+w+FKjDJ4sz1LHE7j4oQZLjXweM+Q7urelD67kBB7UDS/UQrg7?=
 =?us-ascii?Q?T76hBqJZl051xWWZDh+wvUnEiuOPz7cPMjYvr+HsS1Va2lI7uQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <79687C504167C44A85D477121197E766@ausprd01.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MEYPR01MB7886.ausprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: f5a77815-9afe-4b25-b92e-08deb026d1fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2026 13:03:11.0936
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SY9PR01MB9711

On Tue, May 12, 2026 at 08:08:56PM +0800, Zhang Yi wrote:
> On 5/12/2026 3:49 PM, Junrui Luo wrote:
> > jbd2_journal_initialize_fast_commit() validates journal capacity by
> > checking (journal->j_last - num_fc_blks < JBD2_MIN_JOURNAL_BLOCKS).
> > Both j_last and num_fc_blks are unsigned, so when num_fc_blks exceeds
> > j_last the subtraction wraps to a large value, bypassing the bounds
> > check.
>=20
> I'm wondering, how does the "num_fc_blks exceeds j_last" error occur?
> Under normal circumstances, journal->j_last is initialized to
> sb->s_maxlen, which is set to the total number of journal blocks (i.e.,
> the sum of the normal journal area and the fast commit journal area)
> during filesystem formatting by mkfs. Therefore, num_fc_blocks shoud
> never exceed journal->j_last. Right?

Yes, this is triggered by mounting a crafted filesystem where the ext4
superblock has fast_commit enabled but the journal superblock does not,
while s_num_fc_blks is set larger than s_maxlen.

> Have you mounted a deliberately constructed corrupted file system? If
> so, I'd prefer to return EFSCORRUPTED here.
=20
I will change it in v2.

Thanks,
Junrui Luo
