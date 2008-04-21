From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Mentor for a GSoC application wanted (Online ext2/3 filesystem checker)
Date: Mon, 21 Apr 2008 11:45:41 +0200
Message-ID: <87abjn8rsq.fsf@basil.nowhere.org>
References: <f19298770804180720w2e72b821j95b709c1dd1b1c25@mail.gmail.com>
	<20080419012952.GE25797@mit.edu>
	<f19298770804190244y5d6a8502p39f98d1c420135a@mail.gmail.com>
	<20080419185603.GA30449@mit.edu> <480A42F6.2030005@redhat.com>
	<f19298770804201727w37d4f37fs91940caca5d24ad3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Eric Sandeen" <sandeen@redhat.com>,
	"Theodore Tso" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, "Rik van Riel" <riel@surriel.com>
To: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <f19298770804201727w37d4f37fs91940caca5d24ad3@mail.gmail.com> (Alexey Zaytsev's message of "Mon, 21 Apr 2008 04:27:19 +0400")
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

"Alexey Zaytsev" <alexey.zaytsev@gmail.com> writes:
>
> How do you tell data from metadata on this level?

You could always change the file system to pass down hints through
the block layer. 

-Andi
