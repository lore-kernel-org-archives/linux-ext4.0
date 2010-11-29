From: Florian Weimer <fweimer@bfk.de>
Subject: Re: Bug#605009: serious performance regression with ext4
Date: Mon, 29 Nov 2010 16:27:12 +0000
Message-ID: <82oc98f63j.fsf@mid.bfk.de>
References: <20101126093257.23480.86900.reportbug@pluto.milchstrasse.xx>
	<20101129072930.GA7213@burratino> <20101129144436.GT2767@thunk.org>
	<201011291618.25084.bernd.schubert@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Ted Ts'o" <tytso@mit.edu>, Jonathan Nieder <jrnieder@gmail.com>,
	linux-ext4@vger.kernel.org
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx01.bfk.de ([193.227.124.2]:35852 "EHLO mx01.bfk.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755072Ab0K2QeU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Nov 2010 11:34:20 -0500
In-Reply-To: <201011291618.25084.bernd.schubert@fastmail.fm> (Bernd Schubert's message of "Mon\, 29 Nov 2010 16\:18\:24 +0100")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Bernd Schubert:

> Wouldn't it make sense to modify ext4 or even the vfs to do that on c=
lose()=20
> itself? Most applications expect the file to be on disk after a close=
 anyway=20
> and I also don't see a good reason why one should delay a disk write-=
back=20
> after close any longer (well, there are exeption if the application i=
s broken,=20
> for example such as ha-logd used by pacemaker, which did for each lin=
e of logs=20
> an open, seek, write, flush, close sequence..., but at least we have =
fixed=20
> that in -hg now).

If you use Oracle Berkeley DB in a process-based fashion, it is
crucial for decent performance that the memory-mapped file containing
the cache is not flushed to disk when the database environment is
closed prior to process termination.  Perhaps flushing could be
delayed until the last open file handle is gone.  In any case, it's a
pretty drastic change, which should probably be tunable with a
(generic) mount option.

--=20
=46lorian Weimer                <fweimer@bfk.de>
BFK edv-consulting GmbH       http://www.bfk.de/
Kriegsstra=DFe 100              tel: +49-721-96201-1
D-76133 Karlsruhe             fax: +49-721-96201-99
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
