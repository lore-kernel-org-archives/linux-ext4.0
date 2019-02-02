Return-Path: <SRS0=+s2W=QJ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7274C282DA
	for <linux-ext4@archiver.kernel.org>; Sat,  2 Feb 2019 04:08:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94FCC20870
	for <linux-ext4@archiver.kernel.org>; Sat,  2 Feb 2019 04:08:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="Pur5qBcr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbfBBEIT (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 1 Feb 2019 23:08:19 -0500
Received: from mail-eopbgr720090.outbound.protection.outlook.com ([40.107.72.90]:31264
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727715AbfBBEIR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 1 Feb 2019 23:08:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cBnte4vo9sWTXk3yujb6pdyKT40G3jsg9Ym7Sq2JV+s=;
 b=Pur5qBcrW/21UALcO+YyTNaw8revQBZzcoYVCfumBTIlF0BdxeYnBjN2uZLcTrtocaVAuFycot/0MKYsnAcd7TN1+C9K1+aJcGbUGNCZinjDp8g19Oi6GVmHWoQ85eEIVdvK09iXhyALcFn8MZZ0917lNA6a9Lfk1WZ+y9ciq7U=
Received: from CY4PR01CA0014.prod.exchangelabs.com (2603:10b6:903:1f::24) by
 BN6PR01MB3202.prod.exchangelabs.com (2603:10b6:404:d4::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.22; Sat, 2 Feb 2019 04:08:14 +0000
Received: from DM3NAM03FT041.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e49::207) by CY4PR01CA0014.outlook.office365.com
 (2603:10b6:903:1f::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1580.17 via Frontend
 Transport; Sat, 2 Feb 2019 04:08:14 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 DM3NAM03FT041.mail.protection.outlook.com (10.152.83.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1580.10 via Frontend Transport; Sat, 2 Feb 2019 04:08:14 +0000
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x1248Cwn025990
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 1 Feb 2019 23:08:13 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id DEFBD7A4C53; Fri,  1 Feb 2019 23:08:11 -0500 (EST)
Date:   Fri, 1 Feb 2019 23:08:11 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
CC:     Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] Revert "ext4: use ext4_write_inode() when fsyncing w/o a
 journal"
Message-ID: <20190202040811.GB9802@mit.edu>
References: <20190201044219.12802-1-tytso@mit.edu>
 <20190201212119.GB11643@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190201212119.GB11643@quack2.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(346002)(376002)(39860400002)(136003)(396003)(2980300002)(54094003)(199004)(189003)(6916009)(36756003)(75432002)(356004)(14444005)(52956003)(4326008)(23726003)(1076003)(86362001)(6246003)(229853002)(46406003)(4744005)(6266002)(42186006)(16586007)(58126008)(316002)(786003)(8936002)(50466002)(90966002)(8676002)(106466001)(36906005)(88552002)(2906002)(106002)(478600001)(103686004)(76176011)(26826003)(26005)(186003)(305945005)(47776003)(33656002)(97756001)(2616005)(126002)(476003)(336012)(246002)(486006)(11346002)(446003)(18370500001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN6PR01MB3202;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;A:1;MX:1;
X-Microsoft-Exchange-Diagnostics: 1;DM3NAM03FT041;1:NqjMOy54gkqXn5XXHTD8XYJBEBaBg+keJbszvc9oItAVCQvWlYPzS2sAuvsZDyfNMjc46gHMsjbIlLgq7KrU3uuFRsJILx3RMdsy75WlzmGjVDyZ54dEc3G7CnJQFyJZyIE7rGHEUEtyjnieAv/ZRA==
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d217bbe-a678-43ff-ef83-08d688c40dad
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4608076)(4709027)(2017052603328)(7153060);SRVR:BN6PR01MB3202;
X-Microsoft-Exchange-Diagnostics: 1;BN6PR01MB3202;3:hyhEn05rd0kLof/xxuMhmSoIbbENYkL3adFFo6PmW27FyriS6fjZwKfDhXuQU6QmWmXG+ev3V2fMkiWSIeotbEYr/OLpwT6P8TGe3Q/3L1KrZaEaJKuq66zXlt3IOj+qWUaiA3x38TmH071RbH7R2f87e5z8Eyl28nIc/G59Nx2roEa7KOaBE7lgf+JSbR9xWrDxOcX5smY9FqBqK9/3kUFbGlTuZinYUNkRJQPw3uxqBOxMCQDeTxj8U6zaGIE4Zqoziiu+ueM3/pgZo4Q8j35ECCo6Ts1HVzkC1CkAnJmuy41WtAg1bA2byCGDPKEt5KKgcToTdm5OHHWdUBwKD7vzmnzXnmIk7LCH5ZrOyqlB6/sTQrQoqoUjME3ApN0R;25:Dw+7skm+7AqyL0T7YswktbqaxCFCmM9xyOjTTMUTOou8UO1ow83bU9VZAx/R1/oIBVXO9hhUqqFV3h6oYJwCLfKdnNSeg9bSqkW0xaOGhTJ4byNnB0FZh9XXfQHkKFTcHpH2cTxgtwH54/DRC9/FcEfu7UnivSa+lCH49iIR8baO5xbndsRF0wkcbJHRoJDNC67YZOQjffkgKgjU2epAeldIvPPjngkMQfPQ1Y/Z1dYLsZS+juULm3Lkk7u0okgKDbxaEXfsqD1XkZPCecgAvQO5HZjjF3IKoeSGNqCF+xUpZ1Hmi0Rf3KZIi2SHCUYJ97uotfG5S1aFD4aJ0+xrCQ==
X-MS-TrafficTypeDiagnostic: BN6PR01MB3202:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;BN6PR01MB3202;31:3sJ8qgLLRrQmWwbm4XajLB9GQwFDb6z5R0RRC4w2y0SZxKTbBfVhXYtI7wIxf5yoVl3nVGrWfVKrYLpxnEDkl887yIApEDyRaghb0UrZ+NgLmloYbE1jsrjKaZR0iOJnkI+R1XfofQMH/Ci8Xog9BZK0kIzE9fY9a4c+uHb2ze32kIx2lFyE6rY/yBg8vm8B0prl6yAm04ZhauxR++lGEGR+/rpB0q7yyJFiC5UaK5A=;20:FBwheDcyehnKb/Jf4Dm51zKBRWW+mUQDtKzqUTreTWdML3G+YkL0yJJAqIeA4AY+lMn8fLNPzgC8jH9z5jOPq9Esq/VEh5U/4dE/X74z/OJ7PMyGGJPHfEEByo0OLzw7d13jeTRdo3ebTtfAJRvRSsLfiURlII7cmmWbtYJaG7W2pIJaFZKj63NnvI0it7J67rYQR19NeZGm857Z98H8FsZet8flti2as3455+IqXZhEbsRzELmVqF6tJHdIOKvvQ5RlE620t0tykHtvBPMFaROODf0qD5tCriASfXCyhTBMir0zZYc/EDXY+48hXiq+95+667rlJtXHsemPo6/xhZyYPjZX6Q/uEcmRhxHLyYAOVBv3buIHX9KqV9p5irar8I4WSkyOqGd+sVNAjs1uC+jJzyAAlQDHdVjOJsUzNIHOQ71zFs8SyNvYvUi5EFT2u7bz+jf+uxj2bwsZC6Bh81FC/qKfQfAOTtbEaZrUN2HatteUcXh0slBvQY2kr7feCgznT7nZBWmP8l2JWQ/z6VRtw2685YZyBl8hJ+dp73lZ5Whit+4+cX03ysCgBjftD+LWRQFiajAYQQeiR038iK3GrlIdM8iDgQyQkcnjTjg=
X-Microsoft-Antispam-PRVS: <BN6PR01MB32021CB53A5CEE778E180AD1B5930@BN6PR01MB3202.prod.exchangelabs.com>
X-Microsoft-Exchange-Diagnostics: 1;BN6PR01MB3202;4:ueor6VBLq4KpICaElpZtM0f28FGJUrtFNuuKFVwIAVOaByUHjn40HkZIcFrsz+J1xX/8rnE5UtNGe/kgDPiFbkUchBkFE4GM54cYp+pyzHiEb6nRe3uLRqdTv+DYMFy77WPQg0yMmfSv7ZXUsxQgemz8MQP2vUGiRRBIQOtq/0Q2uwSkzhqwb9WwcPuBa/Ek9SMerZrzO8Gc1CMAr9kJAy8wVdpzyUXhCsQCHRpTBio06UxkCtP5XXUehdPCtXgu44jDapo7n673UXI+3uL4273lN1Jh7M4Zb7lmnaLDQd8=
X-Forefront-PRVS: 09368DB063
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;BN6PR01MB3202;23:bPpAxh2FpzwxUp181UEReQkz3MliF4tF2UwPvqxHP?=
 =?us-ascii?Q?qJ46Gl0cFgABb8oBiRK1nZ+QUWqwQqXmruCj3AUvGhQTEnscMrOyRjZu9kas?=
 =?us-ascii?Q?500zowUSphD9bG3F5r3EVIxVyww04zWLw6QqkWb2Xez5qPqywsIm2KM6euQy?=
 =?us-ascii?Q?y5IV2SJglmucAQZebzO7cz8uwLHol25K2BTXzMIhifcdhUtBjXj7cAiyCNpC?=
 =?us-ascii?Q?7bbvz+ahmkCgjwXnPKncQG4xRA1+IHWCjqs17uWZU4IHEJn4nOBz3yjcUXjd?=
 =?us-ascii?Q?ovAQe9RUmgaIFwAwgvKjekl4qGdS2IWxZcFQSgFtIzzED4kZjmMWa8cWMKTP?=
 =?us-ascii?Q?w7bNNdNDK+6guG2SwmJo147P7vvtFseZCl0goP52ltE4CcNru927M1bLTK+R?=
 =?us-ascii?Q?QNqLf76I4WhvqyP8ACnBCuC4xLhALnQyEUWADZCPdyJ/QZEpZYx/kuHqyVab?=
 =?us-ascii?Q?whB3bzrnleyRd17jom9zSx1On1rCGLJudDWVc/eEIF45xzDhlQOk9giI3N0P?=
 =?us-ascii?Q?tIsTmb3FJCKfKLntaAJStPpWqgnDCpuUFwQJ0wTh00zKOEIul+WRbCe3GiE9?=
 =?us-ascii?Q?a3uIM/S2Sb0+SHOf2Ll3f9jHq9fmspyrvi9tPNVMg75LAkBCLUcEmGU05KlW?=
 =?us-ascii?Q?TL2axAnMkH8hifsx25QVg58KkyAXNM4h/cAGkDk6bwwOsqMGTx6cRXlpAuTg?=
 =?us-ascii?Q?u5hoPPZDdRAouwontKln9SRan93kYEXo6pRhcY8bNhxZv1HUbbYU2XhArbNH?=
 =?us-ascii?Q?eXqrXXOqvBiJKouIvW+XR5IgdTUinq8ZyUVIoZ84gJ/uTVHEsZfq54wnv6va?=
 =?us-ascii?Q?/k6NCJ27+mUdWdSr1InF/399Uz6S7khRu6UcJhJN1SoQzUXx2ZT1bXCUJFrf?=
 =?us-ascii?Q?8UwnS2zxVszBdgR4liKQvfoeBahO3wtl4bSCukvp0NPTSg5ek7woQu6J6bj6?=
 =?us-ascii?Q?pivvX7YXfDV27xyCV7GdWuqXJm2Pzxi3tsG62DKvAkCujGI4XwH4zrVxRhDw?=
 =?us-ascii?Q?3fBoJ3xpVAxewh7uzHykup3Lg1lIdWOCNXlKHozLlTxKhvMUlwUUv2rBn46B?=
 =?us-ascii?Q?k1KeTuDeN3mF98t5xKTdsz/LHtnaCY6W+ROI7/3n/c1+RfNFRl4o8TqIoosh?=
 =?us-ascii?Q?Kw3WeIsPHVgDRaL7aZC+6OiGsq0+JMjZWlHJgFVRsrqovnOjZJa1Kh7cgDXo?=
 =?us-ascii?Q?aZvWwg/xWS0ixrfe9UgiyVutSVqn1HPQmCiOkrGLdyl/OnpzXyw1KmPe7nGD?=
 =?us-ascii?Q?WwVMMn6shHv3QjfqqE=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: OLLw2KyFQz/uV5lv+9SUKKaDnQiEiTqb4InbucVHmvUlvhFGPT11AG5pdPKv8GYmaPw+HUpic5V/v9T3SIrrTuD8AnI82Q3GCiPD5Gmcz5JqZ0dUbMf1fXErRFgSpmI89x5g6qgqvLq37Kp+5z/mrFEXyT2LcLza3bbJ5qeJ1hhmeblTFr2SqyMGn7+vaIQkcfF//Mei34R1G1SbpTlanjcRmHZxdMTJ5bFmWiJpuNmYXxT5O5bB+tJD0DDMQnzBZNXHZwzybZ3VSAxGxxDVyxkdNqKucFfvib+xvWw5884Lil4XAp6zBGQ/qEus/7jSdLeW47HB2sTFKaDM4T++tuH5Y4/yE2dXzPqJ2xsPxRZIGhZYk/Hdg5ZLPPISFvTAKd6SF33XqvCVsmFIEe16XSQH0h6PuSf5KZST5WNiHRU=
X-Microsoft-Exchange-Diagnostics: 1;BN6PR01MB3202;6:VpoqH6OWsL20pxDj81vrtfc6a4i3mq8YkbioKKdmNFdCUq8/buWk7iMyEXDK4owNEvOzsuc0KiQME99SkFjaHSrIVQdmtHvOHuzW1EKN6w7HCyy9HJTNYvhu6lAPN59O57crp7BsjMgoP/38bXObsdIdlWW9EZO053hrsmhx9z/SZeAUlFpfeSd7frA2a16IWGsciEMg861IBRzJiX2xo+riLr7DovQQ5XLBjfqXG1/ifEdBPB8jNKFyZg2rMZmuf5/9WCyaiNLjWNvaXPauIKx3hNRPkENtsclBTM5UEmVPcPtav4vpv9yk/7BSef4uuaF1MnipXRHzhhtiCrvNtG7mSKcWKCnPZnHDJ2xLygmBaTl+LM8xCiMFaZYAFXYKjyz7XioQnxn+f7H1YSXZuEa/gnzQ9avtF7CCNtKKUa6NoWWWMGxy8daWveGSTsdUbyytNsyX50GPy6ebOjHRlA==;5:aRG9NIl/ArBYe5Cm7r0cib9Xk0LY0hLennFtOmnjTnR6ZmZrylfdz7pHuWz3NK1PTf6okDHsjKUKFUl90qzZnXZhkegF5nixHRZwItPn3Pb7Op6X1uUwcCi6iZyPKSXmBeKWccU53ImuOjHR/o4x00Dju27qgqo4snqiQbeSUtcTYKSGsuayFnEksOWb6rp07M7GPfC5Y6REgJtU3blApQ==;7:BQc3XAToN+oWmGob5C/ja8vVZO8UeyIoy5eRQmxFQTap6cKtD1z7sUdzHBb3vJMRdNunRLrEXbRfnFybO2gbMkrR5cz6yoHGDJkRHAZglXbOkJZ62ggCeB802QIkwOOjJai8r/6XsvUK+i3aAyD80w==
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2019 04:08:14.1412
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d217bbe-a678-43ff-ef83-08d688c40dad
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR01MB3202
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Feb 01, 2019 at 10:21:20PM +0100, Jan Kara wrote:
> On Thu 31-01-19 23:42:19, Theodore Ts'o wrote:
> > This reverts commit ad211f3e94b314a910d4af03178a0b52a7d1ee0a.
> > 
> > As Jan Kara pointed out, this change was unsafe since it means we lose
> > the call to sync_mapping_buffers() in the nojournal case.  The
> > original point of the commit was avoid taking the inode mutex (since
> > it causes a lockdep warning in generic/113); but we need the mutex in
> > order to call sync_mapping_buffers().
> 
> Actually, I don't think sync_mapping_buffers() needs inode mutex (i_rwsem
> these days). It uses blkdev_mapping->private_lock for synchronization of
> operations on the list of buffers and fsync_buffers_list() seems to be
> pretty careful about races with mark_buffer_dirty_inode(). So why do you
> think we need i_rwsem?

Hmm, I think you're right.  I wonder if we can therefore remove the
inode_lock() in __generic_file_fsync() then...   What do you think?

     			       		      	 - Ted
