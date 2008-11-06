From: Cryptooctoploid <cryptooctoploid@gmail.com>
Subject: Re: data corruption with ext4 (from 2.6.27.4) exposed by rtorrent
Date: Thu, 6 Nov 2008 10:31:43 +0100
Message-ID: <319012f0811060131t18347555m1e544358aabb2201@mail.gmail.com>
References: <3d3ce57e0811030442o377cf2bet212eefba79d714bb@mail.gmail.com>
	 <20081103134008.GE29102@mit.edu>
	 <319012f0811050534i27b7dce1t8120b3a343844adc@mail.gmail.com>
	 <20081105172553.GA29880@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Roc Valles" <vallesroc@gmail.com>, linux-ext4@vger.kernel.org,
	"Jindrich Makovicka" <makovick@gmail.com>,
	Solofo.Ramangalahy@bull.net, torvalds@linux-foundation.org
To: "Theodore Tso" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:35040 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbYKFJbo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Nov 2008 04:31:44 -0500
Received: by wf-out-1314.google.com with SMTP id 27so551074wfd.4
        for <linux-ext4@vger.kernel.org>; Thu, 06 Nov 2008 01:31:43 -0800 (PST)
In-Reply-To: <20081105172553.GA29880@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 5, 2008 at 6:25 PM, Theodore Tso <tytso@mit.edu> wrote:
>
> Based on some reflection and further discussion on #ext4, I have a
> theory which we need to try to prove/disprove that it may be related
> to memory pressure combined with the delayed allocation code.

Jindrich Makovicka wrote:
>The following testcase was used to trigger the infamous MAP_SHARED
>dirty flag bug. Maybe it could be of some help here too:
>
>http://lkml.org/lkml/2006/12/27/180

Solofo.Ramangalahy wrote:
>The test case triggers corruption with 2.6.28-rc3 + ext4 patch queue:
. bunch of errors like
>  Chunk 71637 corrupted (0-1339)  (2756-4095)
>  Expected 213, got 0
>  with default mount.
>. nodelalloc is ok.

I also triggered the bug on my hardware (x86_64, with 2GB memory)
while running Linus' test program with TARGETSIZE (1600 << 20).
The symptoms are exactly the same as in the famous former bug,
that Linus discovered.

Here is an excerpt from the output:

Writing chunk 1149123/1149124 (99%)
Chunk 3 corrupted (0-1459)  (111c-16cf)
Expected 3, got 0
Written as (519444)1144595(687310)
Chunk 15 corrupted (0-1459)  (558c-5b3f)
Expected 15, got 0
Written as (99887)645566(1121294)
Chunk 16 corrupted (0-1215)  (5b40-5fff)
Expected 16, got 0
Written as (645566)1121294(920116)
Chunk 26 corrupted (0-1459)  (9448-99fb)
Expected 26, got 0
Written as (361425)1122832(756521)
Chunk 27 corrupted (0-1459)  (99fc-9faf)
Expected 27, got 0
Written as (1122832)756521(414420)
Chunk 34 corrupted (0-1459)  (c1e8-c79b)
Expected 34, got 0
Written as (204725)934398(543959)
Chunk 39 corrupted (404-1459)  (e000-e41f)
Expected 39, got 0
Written as (857308)1016367(413445)
Chunk 60 corrupted (0-1459)  (15630-15be3)
Expected 60, got 0
Written as (218658)603309(105651)
Chunk 84 corrupted (240-1459)  (1e000-1e4c3)
Expected 84, got 0
Written as (207103)982280(141982)
Chunk 109 corrupted (604-1459)  (27000-27357)
Expected 109, got 0
Written as (415001)965566(309924)
Chunk 114 corrupted (0-1459)  (28a28-28fdb)
Expected 114, got 0
Written as (420741)1107613(233665)
Chunk 119 corrupted (0-1459)  (2a6ac-2ac5f)
Expected 119, got 0
Written as (576520)1013770(680816)
Chunk 129 corrupted (0-1459)  (2dfb4-2e567)
Expected 129, got 0
Written as (272475)1136094(865523)
Chunk 130 corrupted (0-1459)  (2e568-2eb1b)
Expected 130, got 0
Written as (1136094)865523(71027)
Chunk 132 corrupted (0-1459)  (2f0d0-2f683)
Expected 132, got 0
Written as (71027)1087332(516188)
Chunk 139 corrupted (0-1459)  (318bc-31e6f)
Expected 139, got 0
Written as (31550)1035248(265709)
Chunk 141 corrupted (0-1459)  (32424-329d7)
Expected 141, got 0
Written as (265709)1039673(102047)
Chunk 150 corrupted (0-1459)  (35778-35d2b)
Expected 150, got 0
Written as (499376)970317(736517)
Chunk 168 corrupted (0-1459)  (3be20-3c3d3)
Expected 168, got 0
Written as (162733)1104408(467712)
Chunk 199 corrupted (0-275)  (46eec-46fff)
Expected 199, got 0
Written as (277601)946981(262145)
Chunk 212 corrupted (0-1459)  (4b910-4bec3)
Expected 212, got 0
Written as (72548)1090863(578882)
