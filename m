From: "Dolev Raviv" <draviv@codeaurora.org>
Subject: help with bug_on on ext4 mount
Date: Tue, 1 Jul 2014 06:44:45 -0000
Message-ID: <6d9f68dc2278627dbe8d5e5434cf5a78.squirrel@www.codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Tanya Brokhman" <tlinder@codeaurora.org>,
	"Maya Erez" <merez@codeaurora.org>, kdorfman@codeaurora.org,
	lsusman@codeaurora.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:57321 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaGAGop (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Jul 2014 02:44:45 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi All,

I=92m working on a crash originating from ext4 mount path. I=92m runnin=
g with
3.10 based kernel.

Crash description:
I saw a BUG_ON assertion failure in function ext4_clear_journal_err(). =
The
assertion that fails is:  !EXT4_HAS_COMPAT_FEATURE(sb,
EXT4_FEATURE_COMPAT_HAS_JOURNAL).
The strange thing is, that the same BUG_ON assertion is called at the
start of the function that calls ext4_clear_journal_err(), which is
ext4_load_journal(). This means that the capability flag is changed in
ext4_load_journal, before the call for journal_err().

I=92m not too familiar with ext4 code unfortunately. From analyzing the
journal path I came to the below conclusions:
This scenario is possible, if during journal replay, the super_block is
restored or overridden from the journal.
I have noticed a case where the sb is marked as dirty and later, it is
evicted through the address_space_operations .writepage =3D ext4_writep=
age
cb. This cb is using the journal and can cause the dirty sb appear on t=
he
journal. If during the journal write operation a power cut occurs, and =
the
sb copy in the journal is corrupted, it may cause the BUG_ON assertion
failure above.

Is the scenario described above even possible (or am I missing somethin=
g)?
Has anyone encountered similar issues? Are there any known fixes for th=
is?

Thanks,
Dolev
--=20
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a mem=
ber
of Code Aurora Forum, hosted by The Linux Foundation



--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
