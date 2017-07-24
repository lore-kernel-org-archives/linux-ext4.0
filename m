From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: bcache with existing ext4 filesystem
Date: Mon, 24 Jul 2017 21:08:16 +0200
Message-ID: <64c810cf-a95c-f862-f25a-ebd7419b2632@thelounge.net>
References: <20170724185703.GA31422@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Pavel Machek <pavel@ucw.cz>, linux-ext4@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>, tytso@mit.edu,
        kent.overstreet@gmail.com, linux-bcache@vger.kernel.org
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <20170724185703.GA31422@amd>
Content-Language: de-CH
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Am 24.07.2017 um 20:57 schrieb Pavel Machek:
> Would it be feasible to run bcache (write-through) with existing ext4
> filesystem?
> 
> I have 400GB of data I'd rather not move, and SSD I could use for
> caching. Ok, SSD is connecte over USB2, but I guess it is still way
> faster then seeking harddrive on random access

i doubt that seriously - USB2 has a terrible latency
