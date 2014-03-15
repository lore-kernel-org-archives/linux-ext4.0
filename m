From: Phillip Susi <psusi-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] readahead.2: don't claim the call blocks until all data
 has been read
Date: Sat, 15 Mar 2014 12:22:09 -0400
Message-ID: <53247E31.7060002@ubuntu.com>
References: <1394812471-9693-1-git-send-email-psusi@ubuntu.com> <532417CA.1040300@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Corrado Zoccolo <czoccolo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"Gregory P. Smith" <gps-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>,
	Zhu Yanhai <zhu.yanhai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <532417CA.1040300-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On 03/15/2014 05:05 AM, Michael Kerrisk (man-pages) wrote:
> I've tweaked your text a bit to make some details clearer (I hope):
>
>         readahead()  initiates  readahead  on a file so that subsequent
>         reads from that file will, be satisfied from the cache, and not
>         block  on  disk I/O (assuming the readahead was initiated early
>         enough and that other activity on the system  did  not  in  the
>         meantime flush pages from the cache).

Slight grammatical error there: there's an extra comma in "file will, be".


--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
