Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC323EF66A;
	Tue, 30 Jun 2026 10:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782814568; cv=fail; b=oFQ2d2FNy1iRX1SPfQqXa7RN0XrUKLF4KlVjelH7M/4WkJQlpo7ZO+Uqqth1MdawQoceJRbksUHKo6Sa3dL4Qvgw6BgrLV7nAlSRWqYpAaNG9iV7WWXWlF5aAMwA9eeY0C+CEJqtYN3Vid4d8/IskqBmg8CM+9VOXcxl/GYEBiE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782814568; c=relaxed/simple;
	bh=FgXEQ/337pFD72jok4bLVQoE779rfJU+OU7KDVQVtzw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=INFFSPAXV6V60mUmYOTIFxkpp3xJIg7luUO54enzRfX39QSvE7W1i/+47Gx0JaTLv+KiwoKWEkaxgMGCiE0jlcecjvpN7WGTopFoWteocCQ0cMWl6H+tEr27z+vmUTJFF+kmeDymEv6ysqkB2V1/qfPDEsicsu4PKjfmSsREs+0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=F5MMiAU1; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="F5MMiAU1"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65U9oc5r755864;
	Tue, 30 Jun 2026 10:15:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=FkIliC5kfcw3sF3DOWQWasQVlY0CU1CSToax48jUrg8=; b=
	F5MMiAU1ydc+wTh7I+NkYHNLTg/N16ZVzA2u0xD2G47xPIuAoySOEWkJa/Tq+sJf
	4puBHYM3g0Zes7Dhtc04sKEZ6KjB6Zhj+JHGUC4YIQUR3sZldqIRUQfkccvxwEEN
	6Conl7y9eMvlnCHfd/5nRGMBIDrhCvXggW2HZzWw1QOTolfoDDLVuYY7ZGULR/wH
	ci3nfQEdx2ZgrfHsvbFDuQmoQxOUrVu6ZQctY5+BscYa3T41PPHVeVdLmIKy7/w/
	8TabldCh04Cnn7s5p6a5K7RAzLVCAom0mO0i3nRNlXtzBx+e2+9Aliqmo6uqEnVA
	id9YSdN97ZcTdLwLV7UJgw==
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010046.outbound.protection.outlook.com [52.101.61.46])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4f23r0bqhv-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 30 Jun 2026 10:15:41 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QSX61QvMAW68tQ00H3jdxjyea8i8F0gUQKcoMkl0E1b5STNK2epJSys9eKDn+9ToARp2RmrfRiVWLM39AuoHS3lUUiLVhrVZgG0slYQUmxpuvgZdkn/ZRyW4iZ2lTULut1pXVX+iUAQRtPzyZS8EMYT7cN+D3S2O3yWZELE2+fQ7kLCTVmJO6iSGPwQOk3IH1ljn7FWRsKtk5Zs/vHsuINtU/sO02jFJ0xLlT3FLWsDlvoo+yv9Urs+sDn8cAXNAW2aLscINtgI83sQtzmMW4Ywxg10zEMVlowYEISa/TJCUIGlvcyUhydUpeKhAiA/tDPzrBEO2oJlT2l3AxWSUwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FkIliC5kfcw3sF3DOWQWasQVlY0CU1CSToax48jUrg8=;
 b=OT5Pxzr3ES57XzU3+D7F3QTXlUq9jL+ud/o8u2A4nnZOLsAgHrgTNvjMOb+fDhwDJ3kPlPcJWyjDTLnUc7h2Vp2oHpWbedIczxsLGbPH8IZXGmW2dz2RBSqgK4KOs3aC0PG4AtIu3r+Fy5OliyL84yNQHE1bFxns+7xsXvAdJ5MtTTyRkw7Wc0xbZ08g6znm+HDkP1ySEEV9tEe1BHut2dJMqdOnP7HOigYGZSZrjBPvop4XoNS3eVtolD7HelVgn+FMhR9o7P5YkJP7WUuDwYgjQrf0AwDHoqvkutxFnbMzI7hpJvRNScPyEBtDdSm4XwWPxTk2/DRyvaeLG9t8HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by PH7PR11MB5942.namprd11.prod.outlook.com (2603:10b6:510:13e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Tue, 30 Jun
 2026 10:15:37 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0181.008; Tue, 30 Jun 2026
 10:15:37 +0000
Message-ID: <8ea2cd60-f453-47ea-8549-7911a7b28a0d@windriver.com>
Date: Tue, 30 Jun 2026 18:15:29 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 2/4] ext4: introduce ext4_put_ea_inode() for safe
 deferred iput
To: jack@suse.cz
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, ojaswin@linux.ibm.com,
        ritesh.list@gmail.com, yi.zhang@huawei.com, viro@zeniv.linux.org.uk,
        brauner@kernel.org
References: <20260630100829.1257618-1-yun.zhou@windriver.com>
 <20260630100829.1257618-3-yun.zhou@windriver.com>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <20260630100829.1257618-3-yun.zhou@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SE2P216CA0074.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:118::6) To CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|PH7PR11MB5942:EE_
X-MS-Office365-Filtering-Correlation-Id: 08616dfd-32aa-4b1e-7b65-08ded6908789
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|23010399003|376014|366016|22082099003|56012099006|18002099003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	gSl8XmC26tJeXbnAJQ7nnalusJ6op2lXI8IfpF6qTCNfzUir8GuV8iTf46i7RzDzHsgBoryagwxgSOmmfeyW2PgSO3GPL3j6GyPSTSRtAREVqxkebnIQQCrTQZvvwKbBt6RS4mA3Ws90iqC+tB3BqHd49MXXhz183fswK6w1ZRoJ0hq65ghrxvo42pX03UVqwoM5FrbRmgAyaRUHgLaA0vLuzwBnxAG13aFMRg8OXRnOcYrh1HiqKsxxBTeBVX0cISBx+Mql1QCtH7GpAI611XZLhAlV8mQ5PQ3IdbfE+3ZUMczimnVJxE/eCpeJgSqTdJlgQEmnig2qqC3AuxTjzvuVUn1KtMTIhcab9a54GdO9b8kSYFb7CDHKex79kWLSoqtArBNCc9a5nO5ibhEGP41y92JfOzngU7uPXkEQbHX9iCRW0gkTpdx98yXIkw4QZKkcCyuNL9k1oC7REZ6gNT5dOHx3Yy78SkCNd502+ZOiBTETHnTTzsPtW8+ow9XMNf60eprbC84ZWj5oOiYhimUwe7Vp+wesqMGH1vZOmKOvMUqLean0VfLZMylvr8/I873Zg2XMUDoDOdLDl8jXkYFsPdECofLd+MLYdT00hylwhP7ZtKaglU8jbdwC7P25jEjOSJXzYybkqUeYpvsclnKPbwgCocafJC50p69zVf8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(23010399003)(376014)(366016)(22082099003)(56012099006)(18002099003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OWQ3SzdDV0tpOHE3aVgzcStSQktMbTcxa1FRdm1EV2V5SnJYdGJVNGJxOUxm?=
 =?utf-8?B?VWFkMmlKeXNqblF6NEJNdEFoNGRmeVFHTzYrbHJ6RG4wbEdaWmxueEJZNVRN?=
 =?utf-8?B?UnFCaURTSU9zWWVoMlROVzJsRmk5Q2V1dWU4a0tDYjVuU1RIZEFHVVNqZnNr?=
 =?utf-8?B?Qmk3NHdpazEzdERNT0ZNMnl0UUhQVnUxZEpWbUpPT1B2TjkrWm1WS2hYMHpN?=
 =?utf-8?B?YVRtbG5DU29QNVI0MDRzV05KRGdxRHJ0NldLbEhPT1c3RC8wU0poaWlCdmJE?=
 =?utf-8?B?QlcwMnI1cFFGdU1FMmd3ZUNKZWlFYnY1RjM3cTVXV3NQMGNoRTBCMzBnaytL?=
 =?utf-8?B?Rk1IdkJrQ1QyV3hPUkl1L2tpWFptSngzZm5la29wMG5DYmhCbmVSTUc2QWZy?=
 =?utf-8?B?Rnc0Rmh3UDNnWkh4VUtKSk45QzBWQkZ0bENPUVRRYWhQOXJMWXpHNXdmOGlq?=
 =?utf-8?B?bVY3djkzSlhxOVdWa29NVjJpUEl6RHhBd1dNSzgvTlVlbEcyZEx1clpUeUNo?=
 =?utf-8?B?bEpDbjJhTmkzUi9lSnJZNEluaEs2M2JCNzVEVDJOVVRMbjNZZjNvOFVJSGth?=
 =?utf-8?B?aE1TT29oNWlSU0pNcStuaUQ4cm9vYXNTamJoeGwyWjloNWFoTWJVV3dHK3Zw?=
 =?utf-8?B?OHgzQUFFNzNnd0xPZGtYSUFhQktrUWp5MGg5Z2VXQTMrUCtJSnh3cDIwdEJ4?=
 =?utf-8?B?bEdSd2NMSDNzdEdpbUQvZy9UYUtLazJiZ21rMGQ1WThFaG84eURzVm11VjZa?=
 =?utf-8?B?U2o0V1kwRCszaitZTVY2cjlXTG0rOEYzRUJzRys5TDhpNUs2aVlBK0JiV0FB?=
 =?utf-8?B?VzBWdEVzMzRrMlNuTXdhYk0wNTY5Zy8yUjhKd2VMVjVLK0huU2lJT3lOVldS?=
 =?utf-8?B?K0Y0dFRPMytlazZIMDlGVEl1bTB6ZUlTaDc4Si80dXpybWRNbGd3QTFCQjZR?=
 =?utf-8?B?elo5RmxQa3hkMXRBL0ZXMmhZallpWWN3S2x2djRkeVBqUWJFYjRmOFBkVTl0?=
 =?utf-8?B?RE9iOEJPTjJCTFo1WmsyK2RjY1NtQzR4Smkwc2RiZXdadDcyK1Mwd2NXbzda?=
 =?utf-8?B?bllYb2twVU1GYUZSVmdWYWw5VThpRktaWWVHbkJYTmVlMm1xTWFRT3lWM1Vq?=
 =?utf-8?B?aitoOU5MOWhLTWdEZEJRbTJ4elBkcGtZaWZ4aWlhSG1xMW5Ib0dBWjB5Wi9o?=
 =?utf-8?B?ejJEUVVvN1dGdE5oUk9NOFpaL3o4bGlERkM4ZU85VE9wbExJZElMcHVmRmM2?=
 =?utf-8?B?cTExK1dnZFR2QW8xbk8vU0Y2UGREY05sWXNGUGtBSmNYcGhTVWhUanVXQkJk?=
 =?utf-8?B?T2xnUFlpbFQ1WlZBdldseWhwVFBIU0pzbG9iVitRMGk1UnRIVUFtOGdhMUQv?=
 =?utf-8?B?bkVUSS9wbHdGZndMMmhDYXdCaUtSRHB1Q2VHSnJwYldXZXBBcFNpMWpxNDRr?=
 =?utf-8?B?VHE2TEFISHgxTW1HQkR2aWcwM3BiNzYrUTNzZXpZOUlvN1pIL3NhcHJabWUw?=
 =?utf-8?B?dFJlTjYyZW1TSjJSejE4OUgwOS9VYTZlaDFsMzYyRXdnM040R1dHdkRGMm5S?=
 =?utf-8?B?M3JKZWdwem4vTlZoNUZZaGQ1YUg5a2d1OW1lYzhOQWg2SEJsMzI3Smp1VTlG?=
 =?utf-8?B?OXprcDVpdTJpVVZ0TGU4VC8yV1FPQ28zdGsrVStJU0VxZ2JwL2NtUS9rdC83?=
 =?utf-8?B?MS9CMEJWOWF3c1RnUUtvdjVWaDVaQm02aHQyb3hiWjJyZmNIblVnTnFQSDFM?=
 =?utf-8?B?Ym1PVFVFaXV2Z0QzVTVIVnQ3SExxdVlnbCsxaTVxZ29JYnp1R201aG9XTEhW?=
 =?utf-8?B?emZ1UHkwZUc3b3JnUEJzQ1R2MEE2QjBCcUltTCtTMHpCbUNKeXZsTlJmeWdV?=
 =?utf-8?B?KzA5ZjF2UkQ4RXZzb2JiNHNQemE3bFBhbHZ2eFUzYW5MRFdrVTFoZW1PQ3dh?=
 =?utf-8?B?UW16MEQxY3RiQnl6SHo2Qk84V3FCVnJLMDZxQm9RdWNMTnhGYng0NjZTcjNy?=
 =?utf-8?B?VTZ0ZkJ1L1NRUFRwVEhQNms4Z2xLTllUR0lhREVWSkh0SFZuOVlucmpmcVAv?=
 =?utf-8?B?TzBPRHRBN2JDQWQ4aXRzZHFnNk9QM2U5eU0vVm10WTZFb3pCbTJ2WXVoSkVX?=
 =?utf-8?B?UzZyQWxQWDBaV2FGWndOdHpMVjNPcjVtZnNTeEhXNEFESzhpc3R4T3ZYOFhj?=
 =?utf-8?B?b0dhbGpZR1pWbnJ1dHdjTkNKZGpCUkpzL2hOWVcxV3Z1QVVNSnozNW43Y0o4?=
 =?utf-8?B?cVY4RWhaeXJUcERDb21UWlpDUEI3d0R6b1VMektjSUdpRnNuSVFKQm01MTd4?=
 =?utf-8?B?QnBxcm5NbDFBVHNyaVFkcU4vd1lvYm1vQ3BSY21sbnNKRkJrc1RaZz09?=
X-Exchange-RoutingPolicyChecked:
	p84l3E1dFhXooKjqdfUjAVESsxl+H8AW2Rwrd/Cfsz9lCXCQM9UbSyX3ckjqJSAAwioN9Ug1587Wyr4QtqPnybH7PNENRjJufLPcAXG7Io4F4m6MHwpQFITbyXbDzY8cRMqnbIjSbN2SDEVw55gF6yIzATevEHrwFa92FDO7L023cbectF7gjYkrtemBvY8+CJLAFvfa003ZtvHVnZBkZRQJttAOmH2Swqa283+7mloojGSz39LYKZdZiTWRqzPt/2lu1LEZUtv72TC+lPJMGXOwUEH3aZpvuO/dbDQM10v8OW9T+4PEY6cLdk8x/hjH6+vLApYt4+jV/+/ZmO+9gg==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08616dfd-32aa-4b1e-7b65-08ded6908789
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2026 10:15:37.2056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gZlqwtACQVHsIMV00kW8JKlPjq+ETD1UhdexVaXyKmPmwtO28GWut5LMOIelbWfQnsAkcRHHBrZCfoIReXjxUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5942
X-Authority-Analysis: v=2.4 cv=DNC/JSNb c=1 sm=1 tr=0 ts=6a43974d cx=c_pps
 a=JoWddxUZA+6WKbGFiApbuw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=klDOsUkWDRETUCZYPvoE:22
 a=z8U9fzyIrIOSjOexV38A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: ksoXCs4-p6A6RNbCvXiBkcItzsRUI_1v
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjMwMDA5MyBTYWx0ZWRfX2Dq8fCKafD4Q
 UnDDIuXPWKpNNOcqqdxs0JQMqBDnKpkXXe7OKeAVSH1y6YelkgQfuq37W68DqVWs4shkwpI3Hn/
 ytbrPtyFD0Oc8iaYRM/GbTfT2XkmRAZ/bK5f1Yib+OnBhPveDyT3WGkzGhELwGtl7emAlLADL1s
 tIgcd4849+Krpt62iSIo5OWzwPFTeASimxbtC8YEs6OxJ9IEZKsVXnBkDlXma0V6da8ZBdpObKr
 RZdKrzkpXXJTlRuX7nDG+3n+3MtPFl4YJhBoda3nXoxYdzhrFw9eylw8yfVlJ+3FRSAEWu67q80
 hkOVCfTVPYeZcgHPkS03/hvSYowai64JpRoNU02ymATrBEXZxc+sYVjFpbEf5xkgUZnDARJY4iS
 IhjzDVIT063zBxlyhUUhPAqf+uHw4kpVGmATDgJu1PzREOjzIogSFrxFr6Hg2+tcy18Jb9ZC5b5
 r7+LbOpFgrg4KPmuAcQ==
X-Proofpoint-GUID: ksoXCs4-p6A6RNbCvXiBkcItzsRUI_1v
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjMwMDA5MyBTYWx0ZWRfX9RnZg8mMxxB0
 U3u1G532/lUhTsUST2fwZytXA8Z8+SmrpE1OKhO+w7bdJ6Z1r2FY7AqwxtHlE+O7bq88LEUH8q+
 6OjHe+OXftXg+X7t2gjuEZP7sepQFued8ZQB7NVYg5WxEpXwKKx3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-30_03,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606300093

Hi Honza,

On 6/30/26 18:08, Yun Zhou wrote:
> +/*
> + * Release a VFS reference on an EA inode.  Must be used instead of iput()
> + * in any context where xattr_sem or a jbd2 handle is held.
> + *
> + * If this is not the last reference, drops it immediately via
> + * iput_if_not_last() with no further action needed.
> + *
> + * If this is the last reference, the inode is linked onto a per-sb
> + * llist via i_ea_iput_node (embedded in ext4_inode_info, sharing space
> + * with the unused xattr_sem) and a delayed worker performs the final
> + * iput() in a clean context.
> + *
> + * Note: while an inode is on s_ea_inode_to_free, the unconsumed i_count
> + * reference (still 1) keeps it in the inode cache, so any concurrent
> + * iget() bumps i_count to >= 2 and iput_if_not_last() will succeed.
> + * Nobody will add the inode a second time until ext4_ea_inode_work()
> + * drops that reference via iput().
> + */
> +void ext4_put_ea_inode(struct inode *inode)
> +{
> +	if (!inode)
> +		return;
> +	WARN_ON_ONCE(!(EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL));
> +	if (iput_if_not_last(inode))
> +		return;
> +	llist_add(&EXT4_I(inode)->i_ea_iput_node,
> +		  &EXT4_SB(inode->i_sb)->s_ea_inode_to_free);
> +	/*
> +	 * Use a short delay to allow multiple EA inodes to accumulate,
> +	 * reducing workqueue wakeups when several are released together.
> +	 */
> +	schedule_delayed_work(&EXT4_SB(inode->i_sb)->s_ea_inode_work, 1);
> +}
> +

Could you please help me review this patch again? I have reduced the
parameter of ext4_put_ea_inode() to one.
>   
>   extern int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
>   			    struct ext4_inode *raw_inode, handle_t *handle);

Thanks,
Yun
