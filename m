From: =?ISO-8859-1?Q?Pedro_Eug=EAnio_Rocha?=
	<pedro.eugenio.rocha@gmail.com>
Subject: Read operations and journaled data
Date: Tue, 26 Jun 2012 19:58:12 -0300
Message-ID: <CAM3FfDwJhWNO39xrodOFcjQJKE+BD3fNH3t5C5SUtzYubAbGMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f170.google.com ([209.85.216.170]:54197 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab2FZW6N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Jun 2012 18:58:13 -0400
Received: by qcmt36 with SMTP id t36so290753qcm.1
        for <linux-ext4@vger.kernel.org>; Tue, 26 Jun 2012 15:58:12 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi guys,

I have a quick (kind of dumb) question for you about
journaling.

I know that ext4 postpones checkpoints in data journaling
mode, i.e., most of data (and meta-data) are only written
to the journal and checkpointed to their final location only
when certain thresholds are crossed. My question is: how
do ext4 handle read operations to data blocks that are only
written to the journal (supposing that its cache has been
evicted)? Does it execute the read operation in the journaled
data? Does it trigger a checkpoint?

Probably I'm missing something here.

Thanks

--=20
Pedro Eug=EAnio Rocha
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
