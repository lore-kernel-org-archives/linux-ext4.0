From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Re: Atomic file data replace API
Date: Mon, 27 Dec 2010 16:53:49 +0100
Message-ID: <AANLkTin6U1HRR3R8N9hLzkKbtEcG8RMSxLgtS84ZyCOC@mail.gmail.com>
References: <AANLkTi=qpQfwZ1vfRjKE063tVvbz0VLmroO_kkvz+N+-@mail.gmail.com>
	<AANLkTikXAFV6SjWT1gdsR9jZkV+zHr-eFZ0NVFrSEQdg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <AANLkTikXAFV6SjWT1gdsR9jZkV+zHr-eFZ0NVFrSEQdg@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Dec 27, 2010 at 2:20 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> So as I wrote you on the previous thread, in Ext4 you can probably

FS-specific code should of course be avoided in normal apps.

> It is a more granular version of the exchangedata() BSD API mentioned
> in the previous thread:
> http://www.manpagez.com/man/2/exchangedata/
>
> So the atomic update is: write(tempfd); fdatasync(tempfd);
> exchangedata(tempfd, fd)

Except exchangedata is not (widely) implemented?
Don't you agree it's undesirable to lose meta-data?

Olaf
